

//  SaveNoteOperation.swift
//  noteYandexPractice
//
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
//

import Foundation

class SaveNoteOperation: AsyncOperation {
    private let saveToDb: SaveNoteDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        self.dbQueue = dbQueue
        
        super.init()
        
        saveToDb.completionBlock = {
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
            saveToBackend.completionBlock = {
                switch saveToBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
                print("SaveNoteOperation succeeded")
                self.finish()
            }
            backendQueue.addOperation(saveToBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(saveToDb)
    }
}

