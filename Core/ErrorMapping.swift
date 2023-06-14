import Gigya
import OwnIDCoreSDK

extension OwnID.GigyaSDK {
    final class ErrorMapper<AccountType: GigyaAccountProtocol> {
        static func mapRegistrationError(error: LoginApiError<AccountType>, context: String?, authType: String?) {
            switch error.error {
            case .gigyaError(let data):
                let gigyaError = data.errorCode
                if allowedActionsErrorCodes().contains(gigyaError) {
                    OwnID.CoreSDK.eventService.sendMetric(.trackMetric(action: .registered,
                                                                       category: .registration,
                                                                       context: context,
                                                                       authType: authType))
                }
                
            default:
                break
            }
        }
        
        static func mapLoginError(errorCode: Int, context: String?, authType: String?) {
            if allowedActionsErrorCodes().contains(errorCode) {
                OwnID.CoreSDK.eventService.sendMetric(.trackMetric(action: .loggedIn,
                                                                   category: .login,
                                                                   context: context,
                                                                   authType: authType))
            }
        }
        
        private static func allowedActionsErrorCodes() -> [Int] { [206001, 206002, 206006, 403102, 403101] }
    }
}
