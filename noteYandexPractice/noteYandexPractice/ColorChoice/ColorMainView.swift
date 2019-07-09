//
//  ColorMainView.swift
//  noteYandexPractice
//
//  Created by Admin on 09/07/2019.
//  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit
import CocoaLumberjack

@IBDesignable
class ColorMainView : UIView {
    
    @IBInspectable var noteColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var markColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isMarked = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var tapHandler: (() -> Void)?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        fillBackground()
        if isMarked {
            drawMarkCorner()
        }
        drawFrame()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupClickHandlers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupClickHandlers()
    }
    
    private func setupClickHandlers() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(recognizer:))))
    }
    
    @objc func tapHandler(recognizer: UITapGestureRecognizer) {
        self.tapHandler?()
    }
    
    func fillBackground() {
        let path = UIBezierPath(rect: self.bounds)
        noteColor.setFill()
        path.stroke()
        path.fill()
    }
    
    private func drawFrame() {
        let path = UIBezierPath()
        UIColor.black.setStroke()
        path.lineWidth = 1
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0.0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0.0, y: self.bounds.height))
        path.close()
        path.stroke()
    }
    
    private func drawMarkCircle() {
        let path = UIBezierPath()
        path.lineWidth = 2
        path.addArc(
            withCenter: markCenterTopRight,
            radius: bounds.width / 8,
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        
        markColor.setFill()
        markColor.setStroke()
        path.stroke()
        path.fill()
    }
    
    private func drawMarkCorner() {
        let path = UIBezierPath()
        path.lineWidth = 2
        let rect = self.bounds
        path.move(to: CGPoint(x: rect.width  / 2 , y: 0.0))
        path.addLine(to: CGPoint(x: rect.width, y: 0.0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.close()
        let markColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9)
        markColor.setFill()
        path.fill()
    }
    
    private var markCenterTopRight: CGPoint {
        return CGPoint(x: bounds.maxX - bounds.maxX / 4, y: bounds.maxY / 4)
    }
    
}
