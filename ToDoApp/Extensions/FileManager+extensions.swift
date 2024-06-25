//
//  FileManager+extensions.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 25.06.2024.
//

import Foundation

enum FileManagerError: Error {
    case fileNotFound
    case fileIsExist
    case error(String)
}

extension FileManager {
    static func getUrl(fileName: String) throws -> URL {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileManagerError.error("Directory doesn't exists")
        }
        return path.appendingPathComponent(fileName)
    }
    
    static func isExists(fileName: String) -> Bool {
        guard let fileUrl = try? getUrl(fileName: fileName) else {
            return false
        }
        return FileManager.default.fileExists(atPath: fileUrl.path)
    }
}
