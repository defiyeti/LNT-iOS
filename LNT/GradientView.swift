//
//  GradientView.swift
//  LNT
//
//  Created by Henry Popp on 3/31/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.blackColor()
    @IBInspectable var bottomColor: UIColor = UIColor.whiteColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        var topColorComponents = CGColorGetComponents(topColor.CGColor)
        var bottomColorComponents = CGColorGetComponents(bottomColor.CGColor)
        let colors = [topColorComponents[0], topColorComponents[1], topColorComponents[2], topColorComponents[3],
            bottomColorComponents[0], bottomColorComponents[1], bottomColorComponents[2], bottomColorComponents[3]]
        
        let gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), colors, nil, 2)
        let startPoint = CGPoint.zeroPoint
        let endPoint = CGPoint(x: 0.0, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
        
        CGContextRestoreGState(context)
    }
}
