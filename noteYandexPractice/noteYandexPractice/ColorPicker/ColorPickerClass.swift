////
////  ColorPickerClass.swift
////  noteYandexPractice
////
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////

import UIKit

@IBDesignable
class ColorPickerClass: UIView {
    
    @IBInspectable var currentColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    @IBOutlet weak var selectedColorView: ColorSelected!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var paletteView: ColorPalette!
    
    private var baseColor: UIColor = .white
    
    @IBAction func brightnessChanged(_ sender: UISlider) {
        updateUI()
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        colorSelected?(currentColor)
    }
    
    
    
    var colorSelected: ((UIColor)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        
        paletteView.colorChanged = { [weak self] color in
            self?.baseColor = color
            self?.updateUI()
        }
        paletteView.currentColor = self.currentColor
    }
    
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPicker", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    private func updateUI() {
        
        var hue: CGFloat = 0
        var sat: CGFloat = 0
        var br: CGFloat = 0
        var a: CGFloat = 0
        
        baseColor.getHue(&hue, saturation: &sat, brightness: &br, alpha: &a)
        
        br = CGFloat(brightnessSlider.value / (brightnessSlider.maximumValue - brightnessSlider.minimumValue))
        
        currentColor = UIColor(hue: hue, saturation: sat, brightness: br, alpha: a)
        selectedColorView.currentColor = currentColor
        
        setNeedsDisplay()
    }
    
    
    
}

@IBDesignable
class ColorPalette: UIView {
    @IBInspectable var currentColor: UIColor = .white {
        didSet {
            if lastTap == nil {
                lastTap = getPointForColor(color: self.currentColor)
                print("set current point \(lastTap as Any)")
            }
            setNeedsDisplay()
            colorChanged?(currentColor)
        }
    }
    
    var colorChanged: ((UIColor)->Void)?
    
    private let elementSize = CGFloat(2.0)
    private let saturationExponent: Float = 1
    private var lastTap: CGPoint? = nil
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        let rect = CGRect(origin: CGPoint(x: bounds.minX, y: bounds.minY),
                          size: CGSize(width: bounds.maxX, height: bounds.maxY))
        
       
        
        
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
        
        UIColor.black.setStroke()
        let path = UIBezierPath(rect: rect)
        path.stroke()
        
        if let lastTap = lastTap {
            
            let path = CGMutablePath()
            path.addArc(center: lastTap, radius: 7, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            context?.addPath(path.copy()!)
            context?.strokePath()
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        lastTap = touches
            .map { touch -> CGPoint in
                return touch.location(in: self)
            }.last
        if let lastTap = lastTap {
            setNeedsDisplay()
            currentColor = getColorAtPoint(point: lastTap)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        lastTap = touches
            .map { touch -> CGPoint in
                return touch.location(in: self)
            }.last
        if let lastTap = lastTap {
            setNeedsDisplay()
            currentColor = getColorAtPoint(point: lastTap)
        }
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        
        var saturation = CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), saturationExponent))
        
        let brightness = CGFloat(1.0)
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        let percentageY = powf(Float(saturation), 1.0 / saturationExponent)
        let yPos = self.bounds.height - (CGFloat(percentageY) * self.bounds.height)
        let xPos = hue * self.bounds.width
        return CGPoint(x: xPos, y: yPos)
    }
    
}

@IBDesignable
class ColorSelected: UIView {

    @IBInspectable var currentColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        let rect = CGRect(origin: CGPoint(x: bounds.minX, y: bounds.minY),
                          size: CGSize(width: bounds.maxX, height: bounds.maxY))
        
        let radius = CGFloat(10)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: .pi   , endAngle: .pi * 3 / 2, clockwise: false)
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: .pi * 3 / 2 , endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))

        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))

        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: .pi  / 2, endAngle: .pi, clockwise: false)
       
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))

        
        path.closeSubpath()
        
        UIColor.black.setStroke()
        currentColor.setFill()
        
        context?.addPath(path.copy()!)
        
        context?.fillPath()
        context?.strokePath()
        
        
        
    }
}
