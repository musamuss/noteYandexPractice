//
//  LoadNotesOperation.swift
//  noteYandexPractice
//
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
//


import Foundation

class LoadNoteOperation: AsyncOperation {
    private let loadFromDb: LoadNotesDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        self.dbQueue = dbQueue
        
        super.init()
        
        loadFromDb.completionBlock = {
            let loadFromBackend = LoadNotesBackendOperation(notes: notebook.notes)
            loadFromBackend.completionBlock = {
                switch loadFromBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
                print("loadNoteOperation succeeded")
                self.finish()
            }
            backendQueue.addOperation(loadFromBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(loadFromDb)
    }
}
