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
        
        public static func info() -> OwnID.CoreSDK.SDKInformation {
            (sdkName, version)
        }
        
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
        
        /// Creates view model for register flow to manage ``OwnID.FlowsSDK.RegisterView``
        /// - Parameters:
        ///   - instance: Instance of Gigya SDK (with custom schema if needed)
        public static func registrationViewModel<T: GigyaAccountProtocol>(instance: GigyaCore<T>) -> OwnID.FlowsSDK.RegisterView.ViewModel {
            let performer = Registration.Performer(instance: instance, sdkConfigurationName: sdkName)
            let performerLogin = LoginPerformer(instance: instance)
            return OwnID.FlowsSDK.RegisterView.ViewModel(registrationPerformer: performer,
                                                         loginPerformer: performerLogin,
                                                         sdkConfigurationName: sdkName)
        }
        
        /// View that encapsulates management of view and view's state
        /// - Parameter viewModel: ``OwnID.FlowsSDK.RegisterView.ViewModel``
        /// - Parameter email: displayed when loggin in
        public static func createRegisterView(viewModel: OwnID.FlowsSDK.RegisterView.ViewModel,
                                              email: Binding<String>,
                                              visualConfig: OwnID.UISDK.VisualLookConfig = .init()) -> OwnID.FlowsSDK.RegisterView {
            OwnID.FlowsSDK.RegisterView(viewModel: viewModel,
                                        usersEmail: email,
                                        visualConfig: visualConfig)
        }
        
        /// Creates view model for log in flow in Gigya and manages ``OwnID.FlowsSDK.RegisterView``
        /// - Parameters:
        ///   - instance: Instance of Gigya SDK (with custom schema if needed)
        /// - Returns: View model for log in
        public static func loginViewModel<T: GigyaAccountProtocol>(instance: GigyaCore<T>,
                                                                   sdkName: String = sdkName) -> OwnID.FlowsSDK.LoginView.ViewModel {
            let performer = LoginPerformer(instance: instance,
                                           sdkConfigurationName: sdkName)
            return OwnID.FlowsSDK.LoginView.ViewModel(loginPerformer: performer,
                                                      sdkConfigurationName: sdkName)
        }
        
        /// View that encapsulates management of ``OwnID.SkipPasswordView`` state
        /// - Parameter viewModel: ``OwnID.LoginView.ViewModel``
        /// - Parameter usersEmail: Email to be used in link on login and displayed when loggin in
        /// - Parameter visualConfig: contains information about how views will look like
        /// - Returns: View to display
        public static func createLoginView(viewModel: OwnID.FlowsSDK.LoginView.ViewModel,
                                           usersEmail: Binding<String>,
                                           visualConfig: OwnID.UISDK.VisualLookConfig = .init()) -> OwnID.FlowsSDK.LoginView {
            OwnID.FlowsSDK.LoginView(viewModel: viewModel,
                                     usersEmail: usersEmail,
                                     visualConfig: visualConfig)
        }
    }
}
