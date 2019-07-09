//
//  ColorsView.swift
//  noteYandexPractice
//
//  Created by Admin on 09/07/2019.
//  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit
import CocoaLumberjack

enum ClickEvents: String {
    case light = "light"
    case mild = "mild"
    case dark = "dark"
    case custom = "custom"
}

@IBDesignable
class ColorsBarView: UIView {
    
    @IBOutlet weak var colorLight: ColorMainView!
    @IBOutlet weak var colorMild: ColorMainView!
    @IBOutlet weak var colorDark: ColorMainView!
    @IBOutlet weak var colorCustom: ColorPickMarker!
    
    var clickHandler: ((_ color: UIColor?) -> Void)?
    var longPressHandler: ((_ color: ClickEvents) -> Void)?
    
    private var currentSelected: ColorMainView?
    private var currentColor = ClickEvents.light
    private var colors: [ClickEvents: ColorMainView] = [:]
    
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
        colorLight.isMarked = true
        currentSelected = colorLight
        colors[ClickEvents.light] = colorLight
        colors[ClickEvents.mild] = colorMild
        colors[ClickEvents.dark] = colorDark
        colors[ClickEvents.custom] = colorCustom
        
        setupClickHandlers()
    }
    
    private func setupClickHandlers() {
        for (key, value) in self.colors {
            value.tapHandler = {
                self.clickHandler?(value.noteColor)
                self.switchSelected(key)
            }
        }
        colorCustom.tapHandler = {
            if !self.colorCustom.isColorSelected {
                self.clickHandler?(nil)
            } else {
                self.clickHandler?(self.colorCustom.noteColor)
                self.switchSelected(ClickEvents.custom)
            }
        }
        colorCustom.longPressHandler = {
            self.longPressHandler?(ClickEvents.custom)
        }
    }
    
    func switchSelected(_ color: ClickEvents) {
        guard color != currentColor else { return }
        
        colors[currentColor]?.isMarked = false
        currentColor = color
        colors[currentColor]?.isMarked = true
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorsBarView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
}
