//
//  KeychainService.swift
//  EssCore
//
//  Created by Pavlo Boiko on 4/15/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import KeychainAccess

fileprivate var keychainService = "essentia.Essentia"

public enum KeychainOperation<T> {
    case success(T)
    case failure(Error)
}

public typealias KeychainOperationUpdate = (KeychainOperation<Void>) -> Void
public typealias KeychainOperationGet = (KeychainOperation<String?>) -> Void

public class KeychainService: KeychainServiceInterface {
    private let keychain: Keychain
    private let keychainQueue: DispatchQueue
    private let responceQueue: DispatchQueue
    
    public init() {
        keychain = Keychain(service: keychainService)
        keychainQueue = DispatchQueue(label: keychainService, qos: .utility, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        responceQueue = DispatchQueue.main
    }
    
    public func storePassword(userId: String, password: String, result: @escaping KeychainOperationUpdate) {
        keychainQueue.async {
            do {
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .set(password, key: userId)
                self.responceQueue |> (KeychainOperation.success(()), result)
            } catch {
                self.responceQueue |> (KeychainOperation.failure(error), result)
            }
        }
    }
    
    public func getPassword(userId: String, result: @escaping KeychainOperationGet) {
        keychainQueue.async {
            do {
             let pass = try self.keychain
                .authenticationPrompt("Get user password from Keychain")
                .get(userId)
                self.responceQueue |> (KeychainOperation.success(pass), result)
            } catch {
                 self.responceQueue |> (KeychainOperation.failure(error), result)
            }
        }
    }
    
    public func removePassword(userId: String, result: @escaping KeychainOperationUpdate) {
        keychainQueue.async {
            do {
                try self.keychain.remove(userId)
                self.responceQueue |> (KeychainOperation.success(()), result)
            } catch {
                self.responceQueue |> (KeychainOperation.failure(error), result)
            }
        }
    }
}
