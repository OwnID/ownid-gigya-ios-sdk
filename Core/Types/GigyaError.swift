import OwnIDCoreSDK
import Foundation
import Gigya

public extension OwnID.GigyaSDK {
    enum ErrorMessage {
        static let cannotInitSession = "Cannot create session"
        static let cannotParseRegistrationMetadataParameter = "Registration parameters passed are invalid"
        static let cannotParseSession = "Parsing error"
        static let accountNeedsVerification = "Needs account verification"
    }
    
    enum IntegrationError<AccountType: GigyaAccountProtocol>: Swift.Error {
        case login(error: LoginApiError<AccountType>, dataDictionary: [String: Any]?)
        case SDKError(gigyaError: NetworkError, dataDictionary: [String: Any]?)
    }
}

extension OwnID.GigyaSDK.IntegrationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .login(let error, _):
            return error.error.localizedDescription
        case .SDKError(let gigyaError, _):
            switch gigyaError {
            case .gigyaError(let data):
                return data.errorMessage
            case .providerError(let data):
                return data
            case .networkError(let error):
                return error.localizedDescription
            case .jsonParsingError(let error):
                return error.localizedDescription
            default:
                return gigyaError.localizedDescription
            }
        }
    }
}
