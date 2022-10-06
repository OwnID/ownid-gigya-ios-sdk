import OwnIDCoreSDK
import Foundation
import Gigya

public extension OwnID.GigyaSDK {
    enum Error<AccountType: GigyaAccountProtocol>: PluginError {
        case login(error: LoginApiError<AccountType>)
        case gigyaSDK(error: Swift.Error)
        case badIdTokenFormat
        case UIDIsMissing
        case idTokenNotFound
        case emailIsNotValid
        case passwordIsNotValid
        case mainSDKCancelled
        case cannotInitSession
        case cannotParseRegistrationParameters
        case cannotParseRegistrationMetadataParameter
        case cannotParseSession
        case accountNeedsVerification(errorMetadata: ErrorMetadata)
    }
}

extension OwnID.GigyaSDK.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .gigyaSDK(error: let error):
            return error.localizedDescription
        case .login(let error):
            return error.error.localizedDescription
        case .badIdTokenFormat:
            return "Wrong id token format"
        case .emailIsNotValid:
            return "Email is not valid"
        case .passwordIsNotValid:
            return "Password is not valid"
        case .mainSDKCancelled:
            return "Cancelled"
        case .UIDIsMissing:
            return "UID is missing in account"
        case .idTokenNotFound:
            return "ID token is missing"
        case .cannotInitSession:
            return "Cannot create session"
        case .cannotParseRegistrationParameters,
             .cannotParseRegistrationMetadataParameter:
            return "Registration parameters passed are invalid"
        case .cannotParseSession:
            return "Parsing error"
        case .accountNeedsVerification:
            return "Needs account verification"
        }
    }
}

