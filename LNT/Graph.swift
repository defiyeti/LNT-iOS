//
//  Graph.swift
//  LNT
//
//  Created by Henry Popp on 3/23/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

@IBDesignable
class Graph: UIView {
    
    class Plot {
        var points: [(CGFloat, CGFloat)] = [(10.0, 10.0)]
        var strokeColor: UIColor
        var pointRadius: CGFloat = 5.0
        
        init() {
            strokeColor = UIColor.blackColor()
        }
        
        var linePoints: [CGPoint]? {
            get {
                if points.count < 2 {
                    return nil
                }
                
                var firstPoint = CGPoint(x: points[0].0, y: points[0].1)
                var secondPoint = CGPoint(x: points[1].0, y: points[1].1)
                var lines = [firstPoint, secondPoint]
                
                for var i = 1; i < points.count - 1; i++ {
                    lines.append(CGPoint(x: points[i].0, y: points[i].1))
                    lines.append(CGPoint(x: points[i+1].0, y: points[i+1].1))
                }
                return lines
            }
        }
    }
    
    var data: [Plot] = []
    
    @IBInspectable var topColor: UIColor = UIColor.blueColor()
    @IBInspectable var bottomColor: UIColor = UIColor.blueColor()
    @IBInspectable var axisColor: UIColor = UIColor.greenColor()
    
    // MARK: - X Axis
    @IBInspectable var xMin: CGFloat!
    @IBInspectable var xMax: CGFloat!
    @IBInspectable var xIncrements: Int = 1
    
    // MARK: - Y Axis
    var yMin: CGFloat!
    var yMax: CGFloat!
    @IBInspectable var yIncrements: Int = 1
    
    @IBInspectable var axisWidth: CGFloat = 5
    
    // MARK: - Padding
    @IBInspectable var topPadding: CGFloat = 10
    @IBInspectable var bottomPadding: CGFloat = 10
    @IBInspectable var leftPadding: CGFloat = 10
    @IBInspectable var rightPadding: CGFloat = 10
 
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        // Background Gradient
        drawGradient(context)
        
        // X & Y Axes
        CGContextSetLineWidth(context, axisWidth)
        let lines = [CGPoint(x: leftPadding, y: topPadding),
            CGPoint(x: leftPadding, y: self.bounds.height - bottomPadding),
            CGPoint(x: leftPadding, y: self.bounds.height - bottomPadding),
            CGPoint(x: self.bounds.width - rightPadding, y: self.bounds.height - bottomPadding)]
        
        CGContextAddLines(context, lines, 4)
        CGContextSetStrokeColorWithColor(context, axisColor.CGColor)
        CGContextSetShouldAntialias(context, false)
        CGContextStrokePath(context)
        
        for plot in data {
            CGContextSetStrokeColorWithColor(context, plot.strokeColor.CGColor)
            CGContextSetFillColorWithColor(context, plot.strokeColor.CGColor)
            for (x, y) in plot.points {
                CGContextBeginPath(context)
                CGContextAddArc(context, x, y, plot.pointRadius, 0.0, CGFloat(2.0*M_PI), 0)
                CGContextEOFillPath(context)
                CGContextStrokePath(context)
            }
            var lines = plot.linePoints!
//            var adjustedLines: [CGPoint] = []
//            for point in lines {
//                var x = ((point.x - self.xMin) / (self.xMax - self.xMin)) * (self.xMax - self.xMin)
//                var y = ((point.y - self.yMin) / (self.yMax - self.yMin)) * (self.yMax - self.yMin)
//                adjustedLines.append(CGPoint(x: x, y: y))
//            }
            CGContextAddLines(context, lines, UInt(lines.count))
            CGContextSetStrokeColorWithColor(context, plot.strokeColor.CGColor)
            CGContextSetShouldAntialias(context, false)
            CGContextStrokePath(context)
        }
    }
    
    func drawGradient(context: CGContextRef) {
        var topColorComponents = CGColorGetComponents(topColor.CGColor)
        var bottomColorComponents = CGColorGetComponents(bottomColor.CGColor)
        let colors = [topColorComponents[0], topColorComponents[1], topColorComponents[2], topColorComponents[3],
            bottomColorComponents[0], bottomColorComponents[1], bottomColorComponents[2], bottomColorComponents[3]]
        
        let gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), colors, nil, 2)
        let startPoint = CGPoint.zeroPoint
        let endPoint = CGPoint(x: 0.0, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
    }
    
    override func prepareForInterfaceBuilder() {
        var plot = Plot()
        let point = (20.0 as CGFloat, 20.0 as CGFloat)
        let point2 = (40.0 as CGFloat, 30.0 as CGFloat)
        plot.points.append(point)
        plot.points.append(point2)
        plot.strokeColor = UIColor.whiteColor()
        plot.pointRadius = 0.0
        data.append(plot)
    }
}
