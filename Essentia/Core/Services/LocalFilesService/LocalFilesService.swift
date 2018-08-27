//
//  LocalFilesService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class LocalFilesService: LocalFilesServiceInterface {
    
    func getFile<File: Codable>(path: LocalFolderPath, name: String) throws ->  File {
        let url = fileUrl(fromPath: path.path, name: name)
        let fileData = try Data(contentsOf: url)
        guard let file: File = try? JSONDecoder().decode(File.self, from: fileData) else {
            throw NSError(domain: "Unable to get file", code:  404, userInfo: nil)
        }
        return file
    }
    
    func getFilesInFolder<File: Codable>(path: LocalFolderPath) throws -> [File] {
        let pathUrl = fileUrl(fromPath: path.path, name: nil)
        let names = try FileManager.default.contentsOfDirectory(atPath: pathUrl.path)
        return try names.map {
            return try getFile(path: path, name: $0)
        }
    }
    
    func storeFile<File: Codable>(file: File, to path: LocalFolderPath, with name: String) throws {
        let fileData = try JSONEncoder().encode(file)
        let fileManager = FileManager.default
        let directory = directoryPath(currentPath: path.path)
        if !fileManager.fileExists(atPath: directory) {
            try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        }
        let url = fileUrl(fromPath: path.path, name: name)
        try fileData.write(to: url)
    }
    
    func removeFile(at path: LocalFolderPath, with name: String) throws {
        let url = fileUrl(fromPath: path.path, name: name)
        try FileManager.default.removeItem(at: url)
    }
    
    private func directoryPath(currentPath: String) -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        return documentPath.appending(currentPath)
    }
    
    private func fileUrl(fromPath: String, name: String? = nil) -> URL {
        let folder = directoryPath(currentPath: fromPath)
        guard let name = name else {
            return URL(fileURLWithPath: folder, isDirectory: true)
        }
        return URL(fileURLWithPath: folder.appending(name))
    }
}
