//
//  PickedCursor.swift
//  noteYandexPractice
//
//  Created by Admin on 09/07/2019.
//  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit

class PickedCursor: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 2
        path.addArc(
            withCenter: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 4,
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        UIColor.black.setStroke()
        path.stroke()
    }
    
}
