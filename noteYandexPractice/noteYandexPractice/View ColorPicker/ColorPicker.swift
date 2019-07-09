//
//  ColorPicker.swift
//  noteYandexPractice
//
//  Created by Admin on 09/07/2019.
//  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit
import CocoaLumberjack

@IBDesignable
class ColorPicker: UIView {
    
    @IBOutlet weak var colorPalette: ColorPaletteView!
    @IBOutlet weak var pickedColor: UIView!
    @IBOutlet weak var colorString: UILabel!
    @IBOutlet weak var brightnessSlider: UISlider!
    
    private var color: UIColor = UIColor.blue
    
    var willhideWith: ((_ color: UIColor) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    @IBAction func btnDoneClicked(_ sender: UIButton) {
        self.willhideWith?(self.color)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let brightness = CGFloat(sender.value)
        self.color = color.with(brightness: brightness)
        self.colorPalette.sliderBrightness = brightness
        updateUI()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        
        colorPalette.tapHandler = {color in
            self.color = color
            self.updateUI()
        }
        
        self.color = UIColor.fromHex(hexString: "#5BC03E")
        initUI()
    }
    
    private func initUI() {
        updateUI()
        self.brightnessSlider.value = self.color.brightness
        self.colorPalette.color = self.color
        self.pickedColor.layer.cornerRadius = 5
        self.pickedColor.layer.masksToBounds = true
    }
    
    private func updateUI() {
        self.colorString.text = color.hexString
        self.pickedColor.backgroundColor = color
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPicker", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    
}

