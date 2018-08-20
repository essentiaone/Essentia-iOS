//
//  LocalFilesServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

indirect enum LocalFolderPath {
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

protocol LocalFilesServiceInterface {
    func getFile<File>(path: LocalFolderPath, name: String) throws -> File
    func getFilesInFolder<File>(path: LocalFolderPath) throws -> [File]
    func storeFile<File>(file: File, to path: LocalFolderPath, with name: String) throws
    func removeFile(at path: LocalFolderPath, with name: String) throws
}
