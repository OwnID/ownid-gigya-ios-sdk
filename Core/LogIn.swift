import Foundation
import Gigya
import OwnIDCoreSDK
import Combine

extension OwnID.GigyaSDK {
    struct SessionInfo: Decodable {
        let sessionToken: String
        let sessionSecret: String
        let expires_in: String
        
        var expiration: Double {
            Double(expires_in) ?? 0
        }
    }
}

extension OwnID.GigyaSDK {
    public struct ErrorMetadata: Codable {
        public let callID: String?
        public let errorCode: Int?
        public let errorDetails, errorMessage: String?
        public let apiVersion, statusCode: Int?
        public let statusReason, time: String?
        public let registeredTimestamp: Int?
        public let uid, created: String?
        public let createdTimestamp: Int?
        public let identities: [Identity]?
        public let isActive, isRegistered, isVerified: Bool?
        public let lastLogin: String?
        public let lastLoginTimestamp: Int?
        public let lastUpdated: String?
        public let lastUpdatedTimestamp: Int?
        public let loginProvider, oldestDataUpdated: String?
        public let oldestDataUpdatedTimestamp: Int?
        public let profile: Profile?
        public let registered, socialProviders: String?
        public let newUser: Bool?
        public let idToken, regToken: String?

        enum CodingKeys: String, CodingKey {
            case callID = "callId"
            case errorCode, errorDetails, errorMessage, apiVersion, statusCode, statusReason, time, registeredTimestamp
            case uid = "UID"
            case created, createdTimestamp, identities, isActive, isRegistered, isVerified, lastLogin, lastLoginTimestamp, lastUpdated, lastUpdatedTimestamp, loginProvider, oldestDataUpdated, oldestDataUpdatedTimestamp, profile, registered, socialProviders, newUser
            case idToken = "id_token"
            case regToken
        }
    }
    
    public struct Identity: Codable {
        public let provider, providerUID: String?
        public let allowsLogin, isLoginIdentity, isExpiredSession: Bool?
        public let lastUpdated: String?
        public let lastUpdatedTimestamp: Int?
        public let oldestDataUpdated: String?
        public let oldestDataUpdatedTimestamp: Int?
        public let firstName, nickname, email: String?
    }
    
    public struct Profile: Codable {
        public let firstName, email: String?
    }
}

extension OwnID.GigyaSDK {
    enum LogIn {
        static func logIn<T: GigyaAccountProtocol>(instance: GigyaCore<T>, payload: OwnID.CoreSDK.Payload) -> EventPublisher {
            Future<OwnID.LoginResult, OwnID.CoreSDK.CoreErrorLogWrapper> { promise in
                func handle(error: OwnID.GigyaSDK.Error<T>) {
                    promise(.failure(.gigyaLog(entry: .errorEntry(context: payload.context, Self.self), error: .plugin(underlying: error))))
                }
                guard let data = payload.dataContainer as? [String: Any] else { handle(error: .cannotParseSession); return }
                if let errorString = data["errorJson"] as? String,
                   let errorData = errorString.data(using: .utf8),
                   let errorMetadata = try? JSONDecoder().decode(ErrorMetadata.self, from: errorData) {
                    ErrorMapper<T>.mapLoginError(errorCode: errorMetadata.errorCode ?? 0, context: payload.context, authType: payload.authType)
                    handle(error: .accountNeedsVerification(errorMetadata: errorMetadata))
                    return
                }
                guard let sessionData = data["sessionInfo"] as? [String: Any],
                    let jsonData = try? JSONSerialization.data(withJSONObject: sessionData),
                let sessionInfo = try? JSONDecoder().decode(SessionInfo.self, from: jsonData)
                else { handle(error: .cannotParseSession); return }
                
                if let session = GigyaSession(sessionToken: sessionInfo.sessionToken,
                                              secret: sessionInfo.sessionSecret,
                                              expiration: sessionInfo.expiration) {
                    
                    instance.setSession(session)
                    OwnID.CoreSDK.logger.logGigya(.entry(context: payload.context, Self.self))
                    promise(.success(OwnID.LoginResult(operationResult: VoidOperationResult(), authType: payload.authType)))
                } else {
                    handle(error: .cannotInitSession)
                }
            }
            .eraseToAnyPublisher()
        }
    }
}
