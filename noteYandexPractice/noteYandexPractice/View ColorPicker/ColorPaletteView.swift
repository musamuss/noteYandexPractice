//
//  ColorPaletteView.swift
//  noteYandexPractice
//
//  Created by Admin on 09/07/2019.
//  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit
import CocoaLumberjack

protocol ColorPickerDelegate: class{
    func colorDidChange(color: UIColor)
}

@IBDesignable
class ColorPaletteView : UIView {
    
    var tapHandler: ((_ color: UIColor) -> Void)?
    var color = UIColor.red
    var sliderBrightness: CGFloat = 1.0
    
    private let brightness: CGFloat = 1.0
    private let elementSize: CGFloat = 1.0
    private let cursor = PickedCursor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            let saturation = 1.0 - y / rect.height
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
        drawCursor(at: getCursorPosition(for: self.color))
    }
    
    private func setup() {
        self.clipsToBounds = true
        let touchGesture = UITapGestureRecognizer (target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        self.addGestureRecognizer(touchGesture)
        cursor.frame.size = CGSize(width: 20.0, height: 20.0)
        cursor.backgroundColor = UIColor.clear
        self.addSubview(cursor)
    }
    
    @objc func touchedColor(gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        self.tapHandler?(color)
        self.color = color
        drawCursor(at: point)
    }
    
    private func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        let saturation = 1.0 - roundedPoint.y / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: sliderBrightness, alpha: 1.0)
    }
    
    private func getCursorPosition(for color: UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        let xPos = self.bounds.width * hue
        let yPos = self.bounds.height * (1.0 - saturation)
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    private func getCursorRect(at point: CGPoint) -> CGRect {
        let r = CGFloat(5.0)
        return CGRect(x: point.x - r, y: point.y - r, width: 2 * r, height: 2 * r)
    }
    
    private func drawCursor(at point: CGPoint) {
        cursor.center = point
    }
}
