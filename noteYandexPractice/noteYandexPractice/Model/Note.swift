////
////  Note.swift
////  noteYandexPractice
////
////  Created by Admin on 24/06/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////
import UIKit

enum NotePriority : Int {
    case low = 1
    case normal = 2
    case high = 3
}

struct Note {
    var uid: String
    var title: String
    var content: String
    var color: UIColor
    var priority: NotePriority
    var destroyAt: Date?
    
    init(title: String,
         content: String,
         priority: NotePriority,
         uid: String = UUID().uuidString,
         color: UIColor = .white,
         destroyAt: Date? = nil) {
        
        self.title = title
        self.content = content
        self.uid = uid
        self.priority = priority
        self.color = color
        self.destroyAt = destroyAt
        
    }
}
