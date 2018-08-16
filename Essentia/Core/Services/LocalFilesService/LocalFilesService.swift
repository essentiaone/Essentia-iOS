//
//  LocalFilesService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class LocalFilesService: LocalFilesServiceInterface {
    func getFile<File>(path: LocalFolderPath, name: String) throws ->  File {
        let url = fileUrl(fromPath: path.path, name: name)
        let fileData = try Data(contentsOf: url)
        guard let file: File = NSKeyedUnarchiver.unarchiveObject(with: fileData) as? File else {
            throw NSError(domain: "Unable to get file", code:  404, userInfo: nil)
        }
        return file
    }
    
    func getFilesInFolder<File>(path: LocalFolderPath) throws -> [File] {
        let pathUrl = fileUrl(fromPath: path.path, name: nil)
        let names = try FileManager.default.contentsOfDirectory(atPath: pathUrl.path)
        return try names.map {
            return try getFile(path: path, name: $0)
        }
    }
    
    func storeFile<File>(file: File, to path: LocalFolderPath, with name: String) throws {
        let fileData = NSKeyedArchiver.archivedData(withRootObject: file)
        let url = fileUrl(fromPath: path.path, name: name)
        try fileData.write(to: url)
    }
    
    func removeFile(at path: LocalFolderPath, with name: String) throws {
        let url = fileUrl(fromPath: path.path, name: name)
        try FileManager.default.removeItem(at: url)
    }
    
    private func fileUrl(fromPath: String, name: String? = nil) -> URL {
        let folder = FileManager.default.currentDirectoryPath.appending(fromPath)
        guard let name = name else {
            return URL(fileURLWithPath: folder, isDirectory: true)
        }
        return URL(fileURLWithPath: folder.appending(name))
    }
}
