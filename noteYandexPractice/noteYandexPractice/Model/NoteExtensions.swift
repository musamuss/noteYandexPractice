////
////  NoteExtensions.swift
////  noteYandexPractice
////
////  Created by Admin on 20/06/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////
import UIKit

extension Note {
    static func parse(json: [String: Any]) -> Note? {
        guard json["uid"] != nil else {
            return nil
        }
        guard json["title"] != nil else {
            return nil
        }
        guard json["content"] != nil else {
            return nil
        }
        
        let uid = json["uid"] as! String
        let title = json["title"] as! String
        let content = json["content"] as! String
        var priority = NotePriority.normal
        if json["priority"] != nil {
            priority = NotePriority(rawValue: json["priority"] as! Int) ?? priority
        }
        
        var destroyAt: Date? = nil
        if json["destroyAt"] != nil {
            destroyAt = Date(timeIntervalSince1970: json["destroyAt"] as! Double)
        }
        
        var color = UIColor.white
        if json["color"] != nil {
            let rgba = json["color"] as! Array<CGFloat>
            
            color = UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
        }
        
        
        return Note(title: title, content: content, priority: priority, uid: uid, color: color, destroyAt: destroyAt)
        
    }
    
    var json: [String: Any] {
        var dict = [String: Any]()
        dict["uid"] = self.uid
        dict["title"] = self.title
        dict["content"] = self.content
        if self.color != UIColor.white {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.color.getRed(&r, green: &g, blue: &b, alpha: &a)
            dict["color"] = [r,g,b,a]
        }
        if self.priority != NotePriority.normal {
            dict["priority"] = self.priority.rawValue
        }
        if self.destroyAt != nil {
            dict["destroyAt"] = self.destroyAt?.timeIntervalSince1970
        }
        return dict
    }
    
    static var demoNotes: [Note] = [
        Note(title:"Тестовая заметка",content: "тут должен был быть какой то текст", priority: .normal, color: UIColor.green),
        
        ]
}

