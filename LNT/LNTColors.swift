//
//  LNTColors.swift
//  LNT
//
//  Created by Henry Popp on 4/29/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func leaveNoTraceGreen() -> UIColor! {
        return UIColor(red: 96/255.0, green: 199/255.0, blue: 5/255.0, alpha: 1.0)
    }
    
    class func leaveNoTraceYellow() -> UIColor! {
        return UIColor(red: 255/255.0, green: 205/255.0, blue: 62/255.0, alpha: 1.0)
    }
    
    class func leaveNoTraceBlue() -> UIColor! {
        return UIColor(red: 0/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    class func leaveNoTracePink() -> UIColor! {
        return UIColor(red: 230/255.0, green: 0/255.0, blue: 210/255.0, alpha: 1.0)
    }
    
    func darkerColor() -> UIColor {
        var amount: CGFloat = 0.9
        var rgba = UnsafeMutablePointer<CGFloat>.alloc(4)
        
        self.getRed(&rgba[0], green: &rgba[1], blue: &rgba[2], alpha: &rgba[3])
        var darkerColor = UIColor(red: amount*rgba[0], green: amount*rgba[1], blue: amount*rgba[2], alpha: rgba[3])
        
        rgba.destroy()
        rgba.dealloc(4)
        return darkerColor
    }
    
    func lighterColor() -> UIColor {
        var amount: CGFloat = 1.2
        var r = UnsafeMutablePointer<CGFloat>.alloc(1)
        var g = UnsafeMutablePointer<CGFloat>.alloc(1)
        var b = UnsafeMutablePointer<CGFloat>.alloc(1)
        var a = UnsafeMutablePointer<CGFloat>.alloc(1)
        self.getRed(r, green: g, blue: b, alpha: a)
        var lighterColor = UIColor(red: min(1.0, amount*r.memory), green: min(1.0, amount*g.memory), blue: min(1.0, amount*b.memory), alpha: a.memory)
        
        r.destroy(); g.destroy(); b.destroy(); a.destroy()
        r.dealloc(1); g.dealloc(1); b.dealloc(1); a.dealloc(1)
        return lighterColor
    }
}