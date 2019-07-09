//
//  ColorPickMarker.swift
//  noteYandexPractice
//
//  Created by Admin on 09/07/2019.
//  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit
import CocoaLumberjack

@IBDesignable
class ColorPickMarker: ColorMainView {
    
    @IBInspectable var image: UIImage?
    
    var longPressHandler: (() -> Void)?
    
    var isColorSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
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
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.longPressHandler(recognizer:))))
    }
    
    @objc func longPressHandler(recognizer: UITapGestureRecognizer) {
        self.longPressHandler?()
    }
    
    
    override func fillBackground() {
        guard image != nil && !isColorSelected else {
            super.fillBackground()
            return
        }
        
        image!.draw(in: self.bounds)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setNeedsDisplay()
        tapHandler?()
    }
    
}
