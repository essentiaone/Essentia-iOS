//
//  DIRegisteredObject.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public typealias FunctionType = Any
public typealias ObjectType = AnyObject

final class RegisteredObject {
    var objectFactory: AnyObject
    var object: AnyObject?
    let scope: ObjectScope
    
    init(objectFactory: AnyObject, scope: ObjectScope) {
        self.objectFactory = objectFactory
        self.scope = scope
    }
    
    func fetchObject<T>() -> T? {
        switch scope {
        case .transient:
            let obj = (objectFactory as? () -> T)?()
            return obj
        case .container:
            if object == nil {
                object = (objectFactory as? () -> T)?() as AnyObject
            }
            return object as? T
        case .viewController:
            return objectFactory as? T
        }
    }
}

class Storage: StorageInterface {
    private var storage: NSMapTable<NSString, RegisteredObject>!
    fileprivate let lock: NSRecursiveLock
    
    required init() {
        lock = NSRecursiveLock()
        
        storage = NSMapTable(keyOptions: NSPointerFunctions.Options.copyIn,
                             valueOptions: NSPointerFunctions.Options.strongMemory)
    }
    
    // MARK: DependenceStorageInterface
    
    func add(object: RegisteredObject, key: String) {
        self.threadSaveOperation {
            self.storage.setObject(object, forKey: NSString(string: key))
        }
    }
    
    func object(key: String) -> RegisteredObject? {
        var object: RegisteredObject?
        self.threadSaveOperation {
            object = self.storage.object(forKey: NSString(string: key))
        }
        return object
    }
    
    func remove(key: String) {
        self.threadSaveOperation {
            self.storage.removeObject(forKey: NSString(string: key))
        }
    }
    
    func all() -> [RegisteredObject] {
        var allObjects: [RegisteredObject] = []
        self.threadSaveOperation {
                let objectEnumerator = self.storage.objectEnumerator()
                while let object = objectEnumerator?.nextObject() {
                    guard let wrappedObject = object as? RegisteredObject else {
                        continue
                    }
                    allObjects.append(wrappedObject)
                }
        }
        return allObjects
    }
    
    func removeAll() {
        storage.removeAllObjects()
    }
    
    func releaseAllHeldObjects() {
        self.threadSaveOperation {
            let objectEnumerator = self.storage.objectEnumerator()
            while let object = objectEnumerator?.nextObject() {
                if let regObj = object as? RegisteredObject {
                    regObj.object = nil
                }
            }
        }
    }
    
    func threadSaveOperation(block:() -> Void) {
        self.lock.lock()
        block()
        self.lock.unlock()
    }
}
