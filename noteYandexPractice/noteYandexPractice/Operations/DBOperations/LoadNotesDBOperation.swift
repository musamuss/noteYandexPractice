//
//  LoadNotesDBOperation.swift
//  noteYandexPractice
//
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {

    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.loadFromFile()
        print("loadNoteDBOperation succeeded")
        finish()
    }
}
