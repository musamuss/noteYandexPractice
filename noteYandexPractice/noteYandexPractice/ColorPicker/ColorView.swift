//
//  ColorView.swift
//  noteYandexPractice
//
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit



@IBDesignable
class ColorView : UIView {
    
    private var _color: CGColor = UIColor.lightGray.cgColor
    
    var Color: CGColor {
        set {
            _color = newValue
        }
        get {
            return _color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Cant't create DrawingContext")
            return
        }
        
        context.setFillColor(_color)
        context.fill(bounds)
        
        context.setFillColor(UIColor.white.cgColor)
        let textRect = CGRect(x: 0, y: Int(rect.height) - 24, width: Int(rect.width), height: 24)
        context.fill(textRect)
    }
}
