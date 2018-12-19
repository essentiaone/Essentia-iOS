//
//  AppStateEventProxyInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import UIKit

public class AppStateEventProxy: IAppStateEventProxy {
    private var eventSubscribers: [AppStates: [AppStateEventHandler]] = [:]
    public init() {}
    
    private func add(subscriber: AppStateEventHandler, for event: AppStates) {
        if eventSubscribers[event] == nil {
            eventSubscribers[event] = [AppStateEventHandler]()
        }
        eventSubscribers[event]?.append(subscriber)
    }
    
    private func remove(subscriber: AppStateEventHandler, for event: AppStates) {
        if let subscribers = eventSubscribers[event] {
            if let index = subscribers.index(where: { $0 === subscriber }) {
                eventSubscribers[event]?.remove(at: index)
            }
        }
    }
    
    private func notifySubscribers(with event: AppStates) {
        if let subscribers = eventSubscribers[event] {
            for subscriber in subscribers {
                subscriber.receive(event: event)
            }
        }
    }
    
    // MARK: - AppStateEventProxyInterface
    public func add(subscriber: AppStateEventHandler, for events: [AppStates]) {
        for event in events {
            add(subscriber: subscriber, for: event)
        }
    }
    
    public func remove(subscriber: AppStateEventHandler, for events: [AppStates]) {
        for event in events {
            remove(subscriber: subscriber, for: event)
        }
    }
    
    // MARK: - AppEvents
    public func applicationDidEnterBackground(_ application: UIApplication) {
        notifySubscribers(with: .didEnterBackground)
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        notifySubscribers(with: .willEnterForeground)
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        notifySubscribers(with: .didBecomeActive)
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        notifySubscribers(with: .willResignActive)
    }
    
    public func didFinishLaunching(_ application: UIApplication) {
        notifySubscribers(with: .didFinishLaunching)
    }
}
