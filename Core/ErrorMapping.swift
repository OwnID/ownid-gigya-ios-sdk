import Gigya
import OwnIDCoreSDK

extension OwnID.GigyaSDK {
    final class ErrorMapper<AccountType: GigyaAccountProtocol> {
        static func mapRegistrationError(error: LoginApiError<AccountType>, context: String?, authType: String?) {
            switch error.error {
            case .gigyaError(let data):
                let registeredErrorCodes = [206001, 206002, 206006, 403102, 403101]
                let gigyaError = data.errorCode
                if registeredErrorCodes.contains(gigyaError) {
                    sendAnalytic(context: context, authType: authType)
                }
                
            default:
                break
            }
        }
        
        static func sendAnalytic(context: String?, authType: String?) {
            var context = context
            if context == .none {
                context = "no_context"
            }
            OwnID.CoreSDK.logger.logAnalytic(.registerTrackMetric(action: "User is Registered",
                                                                  context: context,
                                                                  authType: authType))
        }
    }
}
