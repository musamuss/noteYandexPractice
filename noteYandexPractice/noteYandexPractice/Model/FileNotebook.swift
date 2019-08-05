////
////  FileNotebook.swift
////  noteYandexPractice
////
////  Created by Admin on 24/06/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////
import UIKit
import CocoaLumberjack


import Foundation
import UIKit
import CocoaLumberjack

class FileNotebook {
    private(set) var notes: [Note] = []
    
    /// функцияя добавленияя новой заметки
    public func add(_ note: Note, override: Bool = false) {
        if override {
            for (index, oldNote) in notes.enumerated() {
                if oldNote.uid == note.uid {
                    notes[index] = note
                    DDLogDebug("Note added with override")
                    return
                }
            }
            notes.append(note)
        } else {
            if let _ = notes.first(where: {$0.uid == note.uid}) {
                DDLogInfo("Запись с таким uid уже существует!")
            } else {
                self.notes.append(note)
                DDLogInfo("Запись добавлена")
            }
        }
    }
    public func remove(with uid: String) {
        self.notes.removeAll(where: { $0.uid == uid })
    }
    
    public func saveToFile() {
        let dirURL = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("notebook")
        let fileURL = dirURL?.appendingPathComponent("n.json")
        
        do {
            try FileManager.default.createDirectory(
                at: dirURL!,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            DDLogInfo("Cant create directory")
        }
        let note_jsons: [[String: Any]] = self.notes.map { $0.json }
        do {
            let data = try JSONSerialization.data(withJSONObject: note_jsons)
            FileManager.default.createFile(atPath: fileURL!.absoluteString, contents: data)
            try data.write(to: fileURL!)
        } catch {
            DDLogInfo("Невозможно создать файл")
        }
    }
    public func loadFromFile() {
        let dirURL = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("notebook")
        guard let fileURL = dirURL?.appendingPathComponent("n.json")
            else { return }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let arr = try JSONSerialization.jsonObject(with: data, options: [])
                as! [[String: Any]] //Array<Dictionary<String, Any>>
            //формируем массив из json
            for obj in arr {
                if let note = Note.parse(json: obj) {
                    self.add(note, override: true)
                }
            }
        } catch {
            DDLogInfo("Невозможно прочитать файл")
        }
    }
}
