//
//  NoteExtensions.swift
//  
//
//  Created by Admin on 22/06/2019.
//

import Foundation
import UIKit

extension Note {
    
    var json: [String: Any] {
        var jsonNote = [String: Any]()
        jsonNote["uid"] = uid
        jsonNote["title"] = title
        jsonNote["content"] = content
        
        if color != UIColor.white {
            var colorRGB = [String: Any]()
            colorRGB["red"] = color.rgba.red
            colorRGB["green"] = color.rgba.green
            colorRGB["blue"] = color.rgba.blue
            colorRGB["alpha"] = color.rgba.alpha
            jsonNote["color"] = colorRGB
        }
        
        if importance != .normal {
            jsonNote["importance"] = importance
        }
        
        if destuctionDate != nil {
            let dateFormatter = DateFormatter()
            let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
            dateFormatter.locale = enUSPosixLocale
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let createdDate = dateFormatter.string(from: destuctionDate!)
            jsonNote["destructionDate"] = createdDate
        }
        return jsonNote
    }
    
    static func parse(json: [String: Any]) -> Note? {
        
        var colorMap: UIColor
        var dateMap: Date?
        var importanceMap: Importance
        
        if let colorRGB = json["color"] as? [String: Double] {
            colorMap = UIColor.init(red: CGFloat(colorRGB["red"]!/255.0),
                                    green: CGFloat(colorRGB["green"]!/255.0),
                                    blue: CGFloat(colorRGB["blue"]!/255.0),
                                    alpha: CGFloat(colorRGB["alpha"]!))
        } else {
            colorMap = UIColor.white
        }
        
        if let importance = json["importance"] as? String {
            if importance == "unImportant" {
                importanceMap = .unimportant
            } else {
                importanceMap = .important
            }
        } else {
            importanceMap = .normal
        }
        
        if let date = json["title"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateMap = dateFormatter.date(from: date)
        } else {
            dateMap = nil
        }
        
        if let title = json["title"] as? String,
            let content = json["content"] as? String,
            let uid = json["uid"] as? String {
            return Note(title: title, content: content, color: colorMap, uid: uid, destuctionDate: dateMap, importance: importanceMap)
        } else {
            return nil
        }
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}

