//
//  FileNotebook.swift
//  noteYandexPractice
//
//  Created by Admin on 24/06/2019.
//  Copyright © 2019 musamuss. All rights reserved.
//

import Foundation
class FileNotebook {
    private(set) var notes: [Note] = []
        
        public func add(_ note: Note) {
            remove(with: note.uid)
            notes.append(note)
        }
        
        public func remove(with uid: String) {
            for (index, note) in notes.enumerated() {
                if note.uid == uid {
                    notes.remove(at: index)
                }
            }
        }
        
        public func saveToFile() {
            guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                return
            }
            
            let dirUrl = path.appendingPathComponent("noteYandexPractice")
            var isDir: ObjCBool = false
            
            if !FileManager.default.fileExists(atPath: dirUrl.absoluteString, isDirectory: &isDir), !isDir.boolValue {
                do {
                    try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true)
                } catch {
                    return
                }
            }
            
            let fileUrl = dirUrl.appendingPathComponent("Notes.sav")
            
            do {
                var dumpedNotes: [[String: Any]] = []
                for n in notes {
                    dumpedNotes.append(n.json)
                }
                let data = try JSONSerialization.data(withJSONObject: dumpedNotes)
                try data.write(to: fileUrl)
            } catch {
                return
            }
        }
        
        public func loadFromFile() {
            guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                return
            }
            
            let dirUrl = path.appendingPathComponent("noteYandexPractice", isDirectory: true)
            let fileUrl = dirUrl.appendingPathComponent("Notes.sav")
            
            do {
                let data = try Data(contentsOf: fileUrl)
                let dumpedNotes = try JSONSerialization.jsonObject(with: data) as! [[String: Any]]
                
                notes.removeAll()
                for dump in dumpedNotes {
                    if let note = Note.parse(json: dump) {
                        notes.append(note)
                    }
                }
                
            } catch {
                return
            }
            
        }
}
