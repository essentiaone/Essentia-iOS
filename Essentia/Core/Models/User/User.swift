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

class User: NSObject, Codable {
    static var defaultPassword: String = ""
    
    static var notSigned = User()
    
    let id: String
    let index: Int
    var profile: UserProfile
    var backup: UserBackup = UserBackup()
    var userEvents: UserEvents = UserEvents()
    var wallet: UserWallet = UserWallet()
    var encodedSeed: Data?
    var encodedMnemonic: Data?
    // For support old versions
    var seed: String?
    var mnemonic: String?
    
    convenience init(mnemonic: String) {
      let seed = (inject() as MnemonicServiceInterface).seed(from: mnemonic)
      self.init(seed: seed)
      self.encodedMnemonic = User.encrypt(data: mnemonic, password: User.defaultPassword)
    }
    
    convenience init(seed: String, image: UIImage, name: String) {
        self.init(seed: seed)
        self.profile = UserProfile(image: image, name: name)
    }
    
    init(seed: String) {
        // That mean you shold re-encode mnemonic and seed before you close app
        User.defaultPassword = Mnemonic.create().md5()
        self.id = String(Int(Date().timeIntervalSince1970))
        self.profile = UserProfile()
        self.index = (inject() as UserStorageServiceInterface).freeIndex
        self.encodedSeed = User.encrypt(data: seed, password: User.defaultPassword)
    }
    
    override init() {
        self.id = ""
        self.encodedSeed = Data()
        self.profile = UserProfile()
        self.index = -1
    }
    
    var dislayName: String {
        return profile.name ?? (LS("Settings.CurrentAccountTitle.Default") + " (\(index))")
    }
    
    static func encrypt(data: String, password: String) -> Data {
        guard let aes = User.aesInstance(withPassword: password),
              let encoded = try? Data(aes.encrypt(data.bytes)) else { return Data() }
        return encoded
    }
    
    func seed(withPassword: String) -> String? {
        if let seed = seed {
            return seed
        }
        guard let aesInstance = User.aesInstance(withPassword: withPassword),
            let encodedSeed = encodedSeed,
            let decrypted = try? aesInstance.decrypt(encodedSeed.bytes) else { return nil }
        return String(bytes: decrypted, encoding: .utf8)
    }
    
    func mnemonic(withPassword: String) -> String? {
        if let mnemonic = mnemonic {
            EssentiaStore.shared.currentUser.backup.currentlyBackedUp.remove(.keystore)
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
