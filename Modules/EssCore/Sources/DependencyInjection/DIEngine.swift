//
//  DIEngine.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public class DIEngine {
    private let storageStrongRef: Storage
    
    public required init() {
        self.storageStrongRef = Storage()
    }
    
    public func load(dependence: AnyObject, key: String, scope: ObjectScope) {
        let object = RegisteredObject(objectFactory: dependence as AnyObject, scope: scope)
        self.storageStrongRef.add(object: object, key: key)
    }
    
    public func resolve<T>(key: String) -> T? {
        guard let registeredObject = self.storageStrongRef.object(key: key) else {
            return nil
        }
        return registeredObject.fetchObject()
    }
    
    public func relese(key: String) {
        storageStrongRef.remove(key: key)
    }
    
    public func removeAll() {
        storageStrongRef.removeAll()
    }
    
    public func releaseAllHeldObjects() {
        storageStrongRef.releaseAllHeldObjects()
    }
}
