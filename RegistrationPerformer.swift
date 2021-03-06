import OwnIDCoreSDK
import OwnIDFlowsSDK
import Gigya
import Combine
import SwiftUI

public extension OwnID.GigyaSDK {
    enum Registration {}
}

extension OwnID.GigyaSDK.Registration {
    public typealias PublisherType = AnyPublisher<OperationResult, OwnID.CoreSDK.Error>
    
    public struct Parameters: RegisterParameters {
        public init(parameters: [String: Any]) {
            self.parameters = parameters
        }
        
        public let parameters: [String: Any]
    }
}

extension OwnID.GigyaSDK.Registration {
    final class Performer<T: GigyaAccountProtocol>: RegistrationPerformer {
        init(instance: GigyaCore<T>, sdkConfigurationName: String) {
            self.instance = instance
            self.sdkConfigurationName = sdkConfigurationName
        }
        
        let instance: GigyaCore<T>
        let sdkConfigurationName: String
        
        func register(configuration: OwnID.FlowsSDK.RegistrationConfiguration, parameters: RegisterParameters) -> PublisherType {
            OwnID.GigyaSDK.Registration.register(instance: instance,
                                                 configuration: configuration,
                                                 parameters: parameters)
        }
    }
}

extension OwnID.GigyaSDK.Registration {
    static func register<T: GigyaAccountProtocol>(instance: GigyaCore<T>,
                                                  configuration: OwnID.FlowsSDK.RegistrationConfiguration,
                                                  parameters: RegisterParameters) -> PublisherType {
        Future<OperationResult, OwnID.CoreSDK.Error> { promise in
            func handle(error: OwnID.GigyaSDK.Error<T>) {
                OwnID.CoreSDK.logger.logGigya(.errorEntry(message: "error: \(error)", Self.self))
                promise(.failure(.plugin(error: error)))
            }
            
            guard configuration.email.isValid else { handle(error: .emailIsNotValid); return }
            guard let gigyaParameters = parameters as? OwnID.GigyaSDK.Registration.Parameters else { handle(error: .cannotParseRegistrationParameters); return }
            guard let metadata = configuration.payload.metadata,
                  let dataField = (metadata as? [String: Any])?["dataField"] as? String
            else { handle(error: .cannotParseRegistrationMetadataParameter); return }
            
            var registerParams = gigyaParameters.parameters
            let ownIDParameters = [dataField: configuration.payload.dataContainer]
            registerParams["data"] = ownIDParameters
            instance.register(email: configuration.email.rawValue,
                              password: OwnID.FlowsSDK.Password.generatePassword().passwordString,
                              params: registerParams
            ) { result in
                switch result {
                case .success(let account):
                    let UID = account.UID ?? ""
                    OwnID.CoreSDK.logger.logGigya(.entry(context: configuration.payload.context, message: "UID \(UID.logValue)", Self.self))
                    promise(.success(VoidOperationResult()))
                    
                case .failure(let error):
                    handle(error: .login(error: error))
                }
            }
        }
        .map { $0 as OperationResult }
        .eraseToAnyPublisher()
    }
}
