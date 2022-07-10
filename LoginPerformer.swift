import OwnIDCoreSDK
import OwnIDFlowsSDK
import Gigya
import Combine

extension OwnID.GigyaSDK.LoginPerformer: LoginPerformer { }

extension OwnID.GigyaSDK {
    final class LoginPerformer<T: GigyaAccountProtocol> {
        private let instance: GigyaCore<T>
        private let sdkConfigurationName: String
        
        init(instance: GigyaCore<T>, sdkConfigurationName: String) {
            self.instance = instance
            self.sdkConfigurationName = sdkConfigurationName
        }
        
        func login(payload: OwnID.CoreSDK.Payload, email: String) -> AnyPublisher<OperationResult, OwnID.CoreSDK.Error> {
            OwnID.GigyaSDK.LogIn.logIn(instance: instance, data: payload.dataContainer as? [String: Any])
                .map { $0 as OperationResult }
                .eraseToAnyPublisher()
        }
    }
}

