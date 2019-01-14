//
//  User.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//
 
import UIKit
import HDWalletKit
import CryptoSwift

fileprivate var iv = "457373656e746961"

public class User: NSObject, Codable {
    public static var defaultPassword: String = ""
    
    public static var notSigned = User()
    
    public let id: String
    public var profile: UserProfile
    public var index: Int
    public var backup: UserBackup = UserBackup()
    public var userEvents: UserEvents = UserEvents()
    public var wallet: UserWallet = UserWallet()
    public var encodedSeed: Data?
    public var encodedMnemonic: Data?
    // For support old versions
    public var seed: String?
    public var mnemonic: String?
    
    public convenience init(mnemonic: String, seed: String, index: Int, name: String) {
      self.init(seed: seed, index: index, name: name)
      self.encodedMnemonic = User.encrypt(data: mnemonic, password: User.defaultPassword)
    }
    
    public convenience init(seed: String, image: UIImage, name: String, index: Int) {
        self.init(seed: seed, index: index, name: name)
        self.profile = UserProfile(image: image, name: name)
    }
    
    public init(seed: String, index: Int, name: String) {
        // That mean you shold re-encode mnemonic and seed before you close app
        User.defaultPassword = Mnemonic.create().md5()
        self.id = String(Int(Date().timeIntervalSince1970))
        self.profile = UserProfile()
        self.index = index
        self.encodedSeed = User.encrypt(data: seed, password: User.defaultPassword)
    }
    
    public override init() {
        self.id = ""
        self.encodedSeed = Data()
        self.profile = UserProfile()
        self.index = -1
    }
    
    public var dislayName: String {
        return profile.name ?? "Essentia account (\(index))"
    }
    
    public static func encrypt(data: String, password: String) -> Data {
        guard let aes = User.aesInstance(withPassword: password),
              let encoded = try? Data(aes.encrypt(data.bytes)) else { return Data() }
        return encoded
    }
    
    public func seed(withPassword: String) -> String? {
        if let seed = seed {
            return seed
        }
        guard let aesInstance = User.aesInstance(withPassword: withPassword),
            let encodedSeed = encodedSeed,
            let decrypted = try? aesInstance.decrypt(encodedSeed.bytes) else { return nil }
        return String(bytes: decrypted, encoding: .utf8)
    }
    
    public func mnemonic(withPassword: String) -> String? {
        if let mnemonic = mnemonic {
            return mnemonic
        }
        guard let aesInstance = User.aesInstance(withPassword: withPassword),
              let encodedMnemonic = encodedMnemonic,
              let decrypted = try? aesInstance.decrypt(encodedMnemonic.bytes) else { return nil }
        return String(bytes: decrypted, encoding: .utf8)
    }
    
    private static func aesInstance(withPassword: String) -> AES? {
        return try? AES(key: withPassword.sha256().md5(), iv: iv)
    }
}
