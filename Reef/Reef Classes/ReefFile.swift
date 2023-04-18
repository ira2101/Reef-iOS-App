//
//  ReefFile.swift
//  Reef
//
//  Created by Ira Einbinder on 3/13/23.
//

import Foundation

class ReefFile {
    var fileName: String
    var fileUrl: URL!
    
    
    required init?(named fileName: String) {
        self.fileName = fileName
        
        let fileManager = FileManager.default
        guard let documentDir = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }
        
        let fileUrl = documentDir.appendingPathComponent(fileName)
        if !fileManager.fileExists(atPath: fileUrl.path) {
            // exit if we are unable to make the file
            if !fileManager.createFile(atPath: fileUrl.path, contents: nil) {
                return nil
            }
        }
        
        self.fileUrl = fileUrl
    }
    
    func readAll(separatedBy separator: CharacterSet) -> [String] {
        let text = try! String(contentsOf: self.fileUrl, encoding: .utf8)
        let searches = text.components(separatedBy: separator)
        return searches
    }
    
    func write(text: String) throws {
        try text.write(toFile: self.fileUrl.path, atomically: false, encoding: .utf8)
    }
    
    
    
    
}
