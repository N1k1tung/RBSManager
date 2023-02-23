//
//  RBSManagerDelegateProxy.swift
//  
//
//  Created by Nikita Rodin on 23.02.23.
//

import Foundation
import Combine
import CombineStarscream

public enum RBSManagerEvent {
    case didDisconnect(Error?)
    case didConnect
    case didThrewError(Error)
}

private final class RBSManagerDelegateProxy: DelegateProxy, RBSManagerDelegate {

    fileprivate let subject = PassthroughSubject<RBSManagerEvent, Never>()

    fileprivate required init() {}

    static func proxy(for manager: RBSManager) -> Self {
        let proxy = delegateProxy(for: manager)
        manager.delegate = proxy
        return proxy
    }

    func manager(_ manager: RBSManager, didDisconnect error: Error?) {
        subject.send(.didDisconnect(error))
    }
    func managerDidConnect(_ manager: RBSManager) {
        subject.send(.didConnect)
    }
    func manager(_ manager: RBSManager, threwError error: Error) {
        subject.send(.didThrewError(error))
    }

}

extension CombineWrapper where Base: RBSManager {
    public var events: some Publisher<RBSManagerEvent, Never> {
        RBSManagerDelegateProxy.proxy(for: self.base).subject
    }
}
