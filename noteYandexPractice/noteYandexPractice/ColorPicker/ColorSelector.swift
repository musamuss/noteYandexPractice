//
//  ColorSelector.swift
////  noteYandexPractice
////
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////

import UIKit
@IBDesignable
class ColorSelector: UIView {
    @IBInspectable private(set) var currentColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var firstColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var secondColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var thirdColor: UIColor = .green {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var customColor: UIColor? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var squareSize: CGSize = CGSize(width: 60, height: 60){
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let colorSquareHorizontalMargin: CGFloat = 8
    private let squareLineWidth: CGFloat = 1
    private var selected: Int = 1
    private var square1: UIBezierPath?
    private var square2: UIBezierPath?
    private var square3: UIBezierPath?
    private var square4: UIBezierPath?
    
    var customColorSelectHandler: (()->Void)?
    var colorSelectHandler: ((UIColor)->Void)?
    
    private func initialize(){
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        addGestureRecognizer(touchGesture)
    }
    
    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
       
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        firstColor.setFill()
        let path1 = getSquarePath(in: CGRect(origin: getSquarePosition(1)!, size: squareSize))
        path1.fill()
        
        secondColor.setFill()
        let path2 = getSquarePath(in: CGRect(origin: getSquarePosition(2)!, size: squareSize))
        path2.fill()
        
        thirdColor.setFill()
        let path3 = getSquarePath(in: CGRect(origin: getSquarePosition(3)!, size: squareSize))
        path3.fill()
        
        let rect = CGRect(origin: getSquarePosition(4)!, size: squareSize)
        let path4 = getSquarePath(in: rect)
        if let customColor = customColor {
            customColor.setFill()
            path4.fill()
        } else {
            UIColor.white.setFill()
            path4.fill()
            
            
            let elementSize = CGFloat(0.5)
            let saturationExponent:Float = 1.5
            
            
            for y in stride(from: rect.minY, to: rect.maxY, by: elementSize) {
                
                var saturation = CGFloat(rect.maxY - y) / rect.height
                saturation = CGFloat(powf(Float(saturation), saturationExponent))
                let brightness = CGFloat(1.0)
                
                for x in stride(from: rect.minX, to: rect.maxX, by: elementSize) {
                    let hue = (x - rect.minX) / rect.width
                    let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                    
                    context!.setFillColor(color.cgColor)
                    context!.fill(CGRect(x:x, y: y, width: elementSize, height: elementSize))
                }
            }
        }
       
        
        square1 = path1
        square2 = path2
        square3 = path3
        square4 = path4
        
        UIColor.black.setStroke()
        let mark = getMark(in: CGRect(origin: getSquarePosition(selected)!, size: squareSize))
        context?.addPath(mark)
        context?.strokePath()
    }
    
    private var touchStart: TimeInterval?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchStart = touches.map { $0.timestamp }.first
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let square1 = square1,
            let square2 = square2,
            let square3 = square3,
            let square4 = square4
            else {
                return
        }
        
        let hitPos = touches
            .map({ touch -> SquareSelected in
                let touchPoint = touch.location(in: self)
                if let touchStart = touchStart { // определяем долгий тап
                    let touchTime = touch.timestamp - touchStart
                    if (touchTime > 0.5) {
                        if (square4.contains(touchPoint)) {
                            return .Select
                        }
                    }
                }
                if (square1.contains(touchPoint)) {
                    return .First
                } else if (square2.contains(touchPoint)) {
                    return .Second
                } else if (square3.contains(touchPoint)) {
                    return .Third
                } else if (square4.contains(touchPoint)) {
                    return .Custom
                } else {
                    return .None
                }
            })
            .filter{$0 != .None }
            .first
        
        if let hitPos = hitPos{
            print(hitPos)
            switch hitPos {
                case .First: setCurrentColor(1, firstColor)
                case .Second: setCurrentColor(2, secondColor)
                case .Third: setCurrentColor(3, thirdColor)
                case .Custom:
                    if let customColor = customColor {
                        setCurrentColor(4, customColor)
                    } else {
                        setCurrentColor(4, currentColor)
                        customColorSelectHandler?()
                    }
                case .Select:
                    setCurrentColor(4, currentColor)
                    customColorSelectHandler?()
                default: break
            }
        }
        
        touchStart = nil
    }
    
    
    func setColor(_ color: UIColor){
        setCurrentColor(0, color)
    }
    
    
    private func setCurrentColor(_ square: Int, _ color: UIColor){
        if square==0 {
            switch color {
            case firstColor:
                selected = 1
            case secondColor:
                selected = 2
            case thirdColor:
                selected = 3
            default:
                customColor = color
                selected = 4
            }
        } else {
            selected = square
        }
        currentColor = color
        colorSelectHandler?(color)
    }
    
    
    func getSquarePosition(_ squareNo: Int) -> CGPoint? {
        guard squareNo>=1 && squareNo<=4 else {
            return nil
        }
        
        let leftMargin = (bounds.maxX - squareSize.width * 4 - colorSquareHorizontalMargin * 3) / 2
        let squareMargin = CGFloat(squareNo - 1) * (squareSize.width + colorSquareHorizontalMargin)
        let x = CGFloat(leftMargin + squareMargin)
        let y = CGFloat(bounds.minY + squareLineWidth)
        return CGPoint(x: x, y: y)
    }
    
    private func getSquarePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = squareLineWidth
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.close()
        path.stroke()
        path.fill()
        return path
    }
    
    private func getMark(in rect: CGRect) -> CGPath {
        // рисуем метку
        let margin = CGFloat(2.0)
        
        // радиус и центр для кружка
        let radius = ((rect.maxX - rect.midX) / 2) - margin
        
        let centerArc = CGPoint(x: (rect.midX + rect.maxX) / 2,
                                y: (rect.minY + rect.midY) / 2)
        // точки для галочки
        let start = CGPoint(x: rect.midX + 3 * margin,
                            y: (rect.minY + rect.midY) / 2)
        let next = CGPoint(x: (rect.midX + rect.maxX) / 2,
                           y: rect.midY - 3 * margin)
        let end = CGPoint(x: rect.maxX - 4 * margin,
                          y: rect.minY + 4 * margin)
        
        let path = CGMutablePath()
        path.addArc(center: centerArc, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        path.move(to: start)
        path.addLine(to: next)
        path.addLine(to: end)
        return path.copy()!
    }
    
    
    enum SquareSelected: Int {
        case First = 1
        case Second = 2
        case Third = 3
        case Custom = 4
        case Select = 5
        case None = 0
    }
}
