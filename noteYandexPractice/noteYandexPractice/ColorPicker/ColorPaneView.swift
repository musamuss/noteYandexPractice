//
//  ColorPaneView.swift
//  noteYandexPractice
//
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit

class ColorPaneView : UIView {
    
    private var heightIncrement: CGFloat {
        return 1.0 / bounds.height
    }
    
    private var widthIncrement: CGFloat {
        return 1.0 / bounds.width
    }
    
    private var solidColor: CGColor? = nil
    private var selected: Bool = false
    
    var Color: CGColor? {
        get {
            return solidColor
        }
        set {
            solidColor = newValue
            setNeedsDisplay()
        }
    }
    
    var Selected: Bool {
        get {
            return selected
        }
        set {
            selected = newValue
            setupUI()
            setNeedsDisplay()
        }
    }
    
    func colorFor(x: CGFloat, y: CGFloat, brightness: CGFloat = 1.0) -> CGColor? {
        
        guard solidColor == nil else {
            return solidColor
        }
        
        guard x >= 0.0,
            x <= bounds.width,
            y >= 0.0,
            y <= bounds.height
            else {
                return nil
        }
        
        return UIColor(
            hue: x * widthIncrement,
            saturation: 1.0 - y * heightIncrement,
            brightness: brightness,
            alpha: 1.0).cgColor
    }
    
    func coordinatesFor(Color : CGColor) -> (CGPoint, CGFloat) {
        var hue: CGFloat = 0.0
        var sat: CGFloat = 0.0
        var bri: CGFloat = 0.0
        var alp: CGFloat = 0.0
        
        UIColor(cgColor: Color).getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)
        
        let x = hue / widthIncrement
        let y = bounds.height - (sat / heightIncrement)
        
        return (CGPoint(x: x, y: y), bri);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Cant't create DrawingContext")
            return
        }
        
        if solidColor == nil {
            for y in 0...Int(rect.height) {
                for x in 0...Int(rect.width) {
                    context.setFillColor(colorFor(x: CGFloat(x), y: CGFloat(y))!)
                    context.fill(CGRect(x: x, y: y, width: 1, height: 1))
                }
            }
        } else {
            if let color = solidColor {
                context.setFillColor(color)
                context.fill(rect)
            }
        }
        
        if selected {
            let checkMarkRect = CGRect(
                x: rect.width - rect.width / 3.0,
                y: 5.0,
                width: rect.width / 3.0 - 5.0,
                height: rect.height / 3.0 - 5.0)
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2.0)
            context.addEllipse(in: checkMarkRect)
            context.drawPath(using: .stroke)
            
            let lineStart = CGPoint(
                x: checkMarkRect.origin.x,
                y: checkMarkRect.origin.y + 2.0)
            let lineInter = CGPoint(
                x: checkMarkRect.origin.x + checkMarkRect.width / 2.0,
                y: checkMarkRect.origin.y + checkMarkRect.height / 1.7)
            let lineEnd = CGPoint(
                x: checkMarkRect.origin.x + checkMarkRect.width + 1.0,
                y: checkMarkRect.origin.y - 1.0)
            context.move(to: lineStart)
            context.addLine(to: lineInter)
            context.addLine(to: lineEnd)
            context.drawPath(using: .stroke)
        }
    }
    
    private func setupUI() {
        layer.borderColor = selected ? UIColor.black.cgColor : UIColor.darkGray.cgColor
        layer.borderWidth = selected ? 2.0 : 1.0
    }
}
