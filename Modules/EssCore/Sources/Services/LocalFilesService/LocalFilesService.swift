//
//  LocalFilesService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public class LocalFilesService: LocalFilesServiceInterface {
    public init() {}
    public func getFile<File: Codable>(path: LocalFolderPath, name: String) throws ->  File {
        let url = fileUrl(fromPath: path.path, name: name)
        let fileData = try Data(contentsOf: url)
        guard let file: File = try? JSONDecoder().decode(File.self, from: fileData) else {
            try removeFile(at: path, with: name)
            (inject() as LoggerServiceInterface).log("File removed at \(path.path)\(name)")
            throw NSError(domain: "Unable to decode file", code: 401, userInfo: nil)
        }
        return file
    }
    
    public func getFilesInFolder<File: Codable>(path: LocalFolderPath) throws -> [File] {
        let pathUrl = fileUrl(fromPath: path.path, name: nil)
        let names = try FileManager.default.contentsOfDirectory(atPath: pathUrl.path)
        return names.compactMap {
            guard let file: File = try? getFile(path: path, name: $0) else {
                return nil
            }
            return file
        }
    }
    
    public func storeData(_ data: Data, to path: LocalFolderPath, with name: String) throws -> URL {
        let fileManager = FileManager.default
        let directory = directoryPath(currentPath: path.path)
        if !fileManager.fileExists(atPath: directory) {
            try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        }
        let url = fileUrl(fromPath: path.path, name: name)
        try data.write(to: url)
        return url
    }
    
    public func storeFile<File: Codable>(file: File, to path: LocalFolderPath, with name: String) throws -> URL {
        let fileData = try JSONEncoder().encode(file)
        return try storeData(fileData, to: path, with: name)
    }
    
    public func removeFile(at path: LocalFolderPath, with name: String) throws {
        let url = fileUrl(fromPath: path.path, name: name)
        try FileManager.default.removeItem(at: url)
    }
    
    public func storageContainFile(at path: LocalFolderPath, with name: String) -> Bool {
        if name.isEmpty { return false }
        let url = fileUrl(fromPath: path.path, name: name)
        return FileManager.default.fileExists(atPath: url.path)
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
