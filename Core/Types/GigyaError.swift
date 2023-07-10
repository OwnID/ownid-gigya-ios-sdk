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
}
