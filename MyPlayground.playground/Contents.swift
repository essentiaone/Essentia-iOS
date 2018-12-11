import UIKit
import HDWalletKit
import CryptoSwift


let pk = "3246cc3ac3245297b17534477bfb754b621e5eab1da4790dc14f44be413c16c4"
let seed = "13ac9d1e68dd2686f7b3de118fc0ceaa1565c39c6d6ed6377a59e4a299a046558437e181f7d7e3bbae84f8a450cf9ba13ee17750934ace616c77d4a1a0cf688c"
let iv = "457373656e746961"
let key = seed.sha256().md5()
print(iv.count)
let aes = try AES(key: key, iv: iv)
let bytes = pk.bytes
let encrypted = try aes.encrypt(bytes)
let dectypted = try aes.decrypt(encrypted)

let newPk = String(bytes: dectypted, encoding: .utf8)

