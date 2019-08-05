//
//  ColorPicker.swift
//  noteYandexPractice
//
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPicker : UIView {
    @IBOutlet weak var colorPaneView: ColorPaneView!
    @IBOutlet weak var selectedColorView: ColorView!
    @IBOutlet weak var selectedColorCode: UILabel!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var cursorView: UIImageView!
    @IBOutlet weak var brightnessBlendView: UIView!
    
    private var _lastSetColor: CGColor? = nil
    
    var onCompletedSelection: ((CGColor?) -> Void)?
    
    func set(Color: CGColor) {
        let coords = colorPaneView.coordinatesFor(Color: Color)
        brightnessSlider.value = Float(coords.1)
        setCursorTo(coords.0)
    }
    
    func getColor() -> CGColor? {
        return getCurrentColor()
    }
    
    func updateCursorPosition() {
        if let color = _lastSetColor {
            set(Color: color)
        }
    }
    
    @IBAction func onColorPicked(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let loc = sender.location(in: colorPaneView)
            setCursorTo(loc)
        }
        let translation = sender.translation(in: colorPaneView)
        moveCursorBy(xDelta: translation.x, yDelta: translation.y)
        sender.setTranslation(CGPoint.zero, in: colorPaneView)
    }
    
    @IBAction func onColorPickedOnce(_ sender: UITapGestureRecognizer) {
        let loc = sender.location(in: colorPaneView)
        setCursorTo(loc)
    }
    
    @IBAction func onChangeBrightness(_ sender: UISlider) {
        brightnessBlendView.alpha = CGFloat(1.0 - sender.value)
        updateColor()
    }
    

    @IBAction func onDoneClicked(_ sender: UIButton) {
        if let completed = onCompletedSelection {
            completed(getColor())
        }
        self.isHidden = true
    }

    private func setCursorTo(_ loc: CGPoint) {
        cursorView.center = loc
        updateColor()
    }
    
    private func moveCursorBy(xDelta: CGFloat, yDelta: CGFloat) {
        let newX = cursorView.center.x + xDelta
        let newY = cursorView.center.y + yDelta
        cursorView.center = CGPoint(
            x: newX,
            y: newY)
        updateColor()
    }
    
    private func getCurrentColor() -> CGColor?  {
        return colorPaneView.colorFor(
            x: cursorView.center.x,
            y: cursorView.center.y,
            brightness: CGFloat(brightnessSlider.value ))
    }
    
    private func updateColor() {
        if let color = getCurrentColor() {
            _lastSetColor = color
            updateColor(Value: color)
        }
    }
    
    private func updateColor(Value: CGColor) {
        guard let components = Value.components else {
            print("Can't get color components")
            return
        }
        let cStr = components.map { value in
            return String(format:"%02X", Int(255.0 * value))
            }.reduce(into: "") { result, value in
                result += value
        }
            
        selectedColorCode.text = "#\(cStr)"
        selectedColorView.Color = Value
        selectedColorView.setNeedsDisplay()
    }
    
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
        setCursorTo(CGPoint(x: 0.0, y: 0.0))
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPicker", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
}
