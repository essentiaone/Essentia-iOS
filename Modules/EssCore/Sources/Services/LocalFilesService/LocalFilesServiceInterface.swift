//
//  LocalFilesServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public indirect enum LocalFolderPath {
    case final(String)
    case subFolder(String, LocalFolderPath)
    
    var path: String {
        switch self {
        case .final(let fileName):
            return "/\(fileName)/"
        case .subFolder(let fileName, let nextFolder):
            let nextFolderPath = nextFolder.path
            return "/\(fileName)\(nextFolderPath)"
        }
    }
}

public protocol LocalFilesServiceInterface {
    func getFile<File: Codable>(path: LocalFolderPath, name: String) throws -> File
    func getFilesInFolder<File: Codable>(path: LocalFolderPath) throws -> [File]
    func storeFile<File: Codable>(file: File, to path: LocalFolderPath, with name: String) throws -> URL
    func storeData(_ data: Data, to path: LocalFolderPath, with name: String) throws -> URL
    func storageContainFile(at path: LocalFolderPath, with name: String) -> Bool
    func removeFile(at path: LocalFolderPath, with name: String) throws
}
