//
//  Note.swift
//  practice1
//
//  Created by Admin on 18/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//
import UIKit
import Foundation

struct Note {
    let title: String
    let content: String
    let color: UIColor
    let uid : String
    let destuctionDate: Date?
    let importance: Importance
    enum Importance {
        case unimportant
        case normal
        case important
    }
    init(title: String, content: String, color: UIColor, uid: String , destuctionDate: Date? , importance: Importance) {
        self.title = title
        self.content = content
        self.color = .white
        self.uid = UUID().uuidString
        self.destuctionDate = nil
        self.importance = importance
    }
}


