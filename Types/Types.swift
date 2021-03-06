import Foundation
import OwnIDCoreSDK
import Combine
import Gigya
import OwnIDFlowsSDK

public extension OwnID.GigyaSDK {
    typealias EventPublisher = AnyPublisher<VoidOperationResult, OwnID.CoreSDK.Error>
}
