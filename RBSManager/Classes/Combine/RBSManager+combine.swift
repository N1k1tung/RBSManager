//
//  RBSManager+combine.swift
//  
//
//  Created by Nikita Rodin on 21.02.23.
//

import Foundation
import Combine

extension RBSManager {

    private final class RBSSubscription<T: RBSMessage, S: Subscriber>: Subscription where S.Input == T {

        private var subscriber: S?
        private var rbsSubscriber: RBSSubscriber?
        private weak var manager: RBSManager?

        init(subscriber: S, manager: RBSManager, topic: String) {
            self.subscriber = subscriber
            self.manager = manager

            self.rbsSubscriber = manager.addSubscriber(topic: topic, messageClass: T.self) { [weak self] message in
                guard let message = message as? T else { return }
                _ = self?.subscriber?.receive(message)
            }
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
            if let rbsSubscriber, rbsSubscriber.connected {
                rbsSubscriber.unsubscribe()
            }
        }
    }

    private struct RBSSubscriptionPublisher<T: RBSMessage>: Publisher {
        typealias Output = T
        typealias Failure = Never

        fileprivate let manager: RBSManager
        fileprivate let topic: String

        func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let subscription = RBSSubscription(
                subscriber: subscriber,
                manager: manager,
                topic: topic
            )
            subscriber.receive(subscription: subscription)
        }
    }

    public func addSubscriber<T: RBSMessage>(topic: String, messageClass: T.Type) -> AnyPublisher<T, Never> {
        RBSSubscriptionPublisher<T>(manager: self, topic: topic)
            .eraseToAnyPublisher()
    }


}
