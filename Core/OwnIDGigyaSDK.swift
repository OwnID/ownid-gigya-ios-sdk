@_exported import OwnIDCoreSDK
import Combine
import SwiftUI
import Gigya

public extension OwnID.GigyaSDK {
    static let sdkName = "Gigya"
    static let version = "2.2.0"
}

public extension OwnID {
    final class GigyaSDK {
        
        // MARK: Setup
        
        public static func info() -> OwnID.CoreSDK.SDKInformation { (sdkName, version) }
        
        /// Standard configuration, searches for default .plist file
        public static func configure(supportedLanguages: OwnID.CoreSDK.Languages = .init(rawValue: Locale.preferredLanguages)) {
            OwnID.CoreSDK.shared.configure(userFacingSDK: info(), underlyingSDKs: [], supportedLanguages: supportedLanguages)
        }
        
        /// Configures SDK from plist path URL
        public static func configure(plistUrl: URL,
                                     supportedLanguages: OwnID.CoreSDK.Languages = .init(rawValue: Locale.preferredLanguages)) {
            OwnID.CoreSDK.shared.configureFor(plistUrl: plistUrl,
                                              userFacingSDK: info(),
                                              underlyingSDKs: [],
                                              supportedLanguages: supportedLanguages)
        }
        
        public static func configure(appID: OwnID.CoreSDK.AppID,
                                     redirectionURL: OwnID.CoreSDK.RedirectionURLString,
                                     environment: String? = .none,
                                     supportedLanguages: OwnID.CoreSDK.Languages = .init(rawValue: Locale.preferredLanguages)) {
            OwnID.CoreSDK.shared.configure(appID: appID,
                                           redirectionURL: redirectionURL,
                                           userFacingSDK: info(),
                                           underlyingSDKs: [],
                                           environment: environment,
                                           supportedLanguages: supportedLanguages)
        }
        
        /// Handles redirects from other flows back to the app
        public static func handle(url: URL) {
            OwnID.CoreSDK.shared.handle(url: url, sdkConfigurationName: sdkName)
        }
        
        // MARK: View Model Flows
        
        /// Creates view model for register flow to manage `OwnID.FlowsSDK.RegisterView`
        /// - Parameters:
        ///   - instance: Instance of Gigya SDK (with custom schema if needed)
        public static func registrationViewModel<T: GigyaAccountProtocol>(instance: GigyaCore<T>,
                                                                          emailPublisher: OwnID.CoreSDK.EmailPublisher) -> OwnID.FlowsSDK.RegisterView.ViewModel {
            let performer = Registration.Performer(instance: instance, sdkConfigurationName: sdkName)
            let performerLogin = LoginPerformer(instance: instance)
            return OwnID.FlowsSDK.RegisterView.ViewModel(registrationPerformer: performer,
                                                         loginPerformer: performerLogin,
                                                         sdkConfigurationName: sdkName,
                                                         emailPublisher: emailPublisher)
        }
        
        public static func createRegisterView(viewModel: OwnID.FlowsSDK.RegisterView.ViewModel,
                                              visualConfig: OwnID.UISDK.VisualLookConfig = .init()) -> OwnID.FlowsSDK.RegisterView {
            OwnID.FlowsSDK.RegisterView(viewModel: viewModel, visualConfig: visualConfig)
        }
        
        /// Creates view model for login flow to manage `OwnID.FlowsSDK.LoginView`
        /// - Parameters:
        ///   - instance: Instance of Gigya SDK (with custom schema if needed)
        public static func loginViewModel<T: GigyaAccountProtocol>(instance: GigyaCore<T>,
                                                                   emailPublisher: OwnID.CoreSDK.EmailPublisher) -> OwnID.FlowsSDK.LoginView.ViewModel {
            let performer = LoginPerformer(instance: instance)
            return OwnID.FlowsSDK.LoginView.ViewModel(loginPerformer: performer,
                                                      sdkConfigurationName: sdkName,
                                                      emailPublisher: emailPublisher)
        }
        
        public static func createLoginView(viewModel: OwnID.FlowsSDK.LoginView.ViewModel,
                                           visualConfig: OwnID.UISDK.VisualLookConfig = .init()) -> OwnID.FlowsSDK.LoginView {
            OwnID.FlowsSDK.LoginView(viewModel: viewModel, visualConfig: visualConfig)
        }
    }
}
