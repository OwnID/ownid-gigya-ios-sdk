import Gigya
import OwnIDCoreSDK

extension OwnID.GigyaSDK {
    final class ErrorMapper<AccountType: GigyaAccountProtocol> {
        static func mapRegistrationError(error: LoginApiError<AccountType>, context: String?, authType: String?) {
            switch error.error {
            case .gigyaError(let data):
                let gigyaError = data.errorCode
                if allowedActionsErrorCodes().contains(gigyaError) {
                    OwnID.CoreSDK.logger.logAnalytic(.registerTrackMetric(action: .registered,
                                                                          context: context,
                                                                          authType: authType))
                }
                
            default:
                break
            }
        }
        
        static func mapLoginError(errorCode: Int, context: String?, authType: String?) {
            if allowedActionsErrorCodes().contains(errorCode) {
                OwnID.CoreSDK.logger.logAnalytic(.loginTrackMetric(action: .loggedIn,
                                                                   context: context,
                                                                   authType: authType))
            }
        }
        
        private static func allowedActionsErrorCodes() -> [Int] { [206001, 206002, 206006, 403102, 403101] }
    }
}
