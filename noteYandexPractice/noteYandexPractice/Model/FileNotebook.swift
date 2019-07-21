////
////  FileNotebook.swift
////  noteYandexPractice
////
////  Created by Admin on 24/06/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////
import UIKit
import CocoaLumberjack

class FileNotebook {
    
    init(notes: [Note]) {
        for note in notes {
            add(note)
        }
    }
    
    public private(set) var notes: [Note] = []
    
    public var newNote: Note?
    
    public func add(_ note: Note){
        DDLogInfo("FileNotebook.add(note \(note))")
        let index = notes.firstIndex{ $0.uid == note.uid }
        if let index = index {
            notes.remove(at: index)
            notes.insert(note, at: index)
        } else {
            notes.append(note)
        }
    }
    
    public func remove(with uid: String) {
        DDLogInfo("FileNotebook.remove(with uid:\(uid))")
        notes.removeAll { $0.uid == uid }
    }
    
    public func saveToFile() {
        DDLogInfo("FileNotebook.saveToFile()")
        
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard path != nil else {
            return
        }
        
        let dir = path!.appendingPathComponent("Notebooks", isDirectory: true)
        var isDir: ObjCBool = false
        
        if !FileManager.default.fileExists(atPath: dir.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true,
                                                        attributes: [:])
            } catch { }
        }
        let filename = dir.appendingPathComponent("FileNotebook.data")
        do {
            let data = try JSONSerialization.data(withJSONObject: notes.map { $0.json }, options: [])
            //FileManager.default.createFile(atPath: filename.path, contents: data, attributes: [:])
            try data.write(to: filename)
        } catch { }
    }
    
    public func loadFromFile() {
        DDLogInfo("FileNotebook.loadFromFile()")
        var path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard path != nil else {
            return
        }
        notes.removeAll()
        
        path = path!.appendingPathComponent("Notebooks", isDirectory: true)
        path = path!.appendingPathComponent("FileNotebook.data", isDirectory: false)
        
        if FileManager.default.fileExists(atPath: path!.path) {
            do {
                let data = try Data.init(contentsOf: path!)
                let items = try JSONSerialization.jsonObject(with: data, options: []) as! Array<[String: Any]>
                for i in items {
                    let note = Note.parse(json: i)
                    if note != nil {
                        self.add(note!)
                    }
                }
            } catch { }
        }
    }
}
