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
        var points: [Point] = []
        var strokeColor: UIColor
        var strokeWidth: CGFloat = 1.0
        var pointRadius: CGFloat = 2.0
        var xRange = 100.0
        
        init() {
            strokeColor = UIColor.blackColor()
        }
        
        var linePoints: [CGPoint]? {
            get {
                if points.count < 2 {
                    return nil
                }
                let xIncrement: CGFloat = CGFloat(xRange) / CGFloat(points.count)
                var firstPoint = CGPoint(x: 0.0, y: points[0].value)
                let y = points[1].value
                var secondPoint = CGPoint(x: xIncrement, y: points[1].value)
                var lines = [firstPoint, secondPoint]
                
                for var i = 1; i < points.count - 1; i++ {
                    let x1 = xIncrement * CGFloat(i)
                    let x2 = xIncrement * CGFloat(i+1)
                    lines.append(CGPoint(x: x1, y: points[i].value))
                    lines.append(CGPoint(x: x2, y: points[i+1].value))
                }
                return lines
            }
        }
    }
    
    struct Point {
        var object: AnyObject
        var value: CGFloat
        
        init(object: AnyObject, value: CGFloat) {
            self.object = object
            self.value = value
        }
    }
    
    var data: [Plot] = []
    
    @IBInspectable var topColor: UIColor = UIColor.blueColor()
    @IBInspectable var bottomColor: UIColor = UIColor.blueColor()
    @IBInspectable var axisColor: UIColor = UIColor.greenColor()
    @IBInspectable var xAxisLabel: String = ""
    @IBInspectable var yAxisLabel: String = ""
    
    // MARK: - X Axis
    @IBInspectable var xMin: CGFloat = 0
    @IBInspectable var xMax: CGFloat = 100
    
    // MARK: - Y Axis
    @IBInspectable var yMin: CGFloat = 0
    @IBInspectable var yMax: CGFloat = 100
    
    // @IBDesignable: Padding
    // MARK: - Padding
    @IBInspectable var axisWidth: CGFloat = 5
    @IBInspectable var topPadding: CGFloat = 10
    @IBInspectable var bottomPadding: CGFloat = 10
    @IBInspectable var leftPadding: CGFloat = 10
    @IBInspectable var rightPadding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
//        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        self.contentMode = UIViewContentMode.Redraw
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
    }
 
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        // Background Gradient
        drawGradient()
        
        // X & Y Axes
        drawAxes(context, strokeColor: axisColor)
        for plot in data {
            var points = projectPoints(plot.points, xMin: xMin, yMin: yMin, xMax: xMax, yMax: yMax)
            drawDataPoints(context, pointRadius: plot.pointRadius, strokeColor: plot.strokeColor, fillColor: plot.strokeColor, points: points)
            drawLines(plot.strokeWidth, strokeColor: plot.strokeColor, points: points)
        }
        
        drawLabels()
        
        CGContextRestoreGState(context)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    func drawGradient() {
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
    
    func drawAxes(context: CGContextRef, strokeColor: UIColor) {
        CGContextSetLineWidth(context, axisWidth)
        let topLine = [CGPoint(x: leftPadding, y: topPadding),
            CGPoint(x: self.bounds.width - rightPadding, y: topPadding)]
        let bottomLine = [CGPoint(x: leftPadding, y: self.bounds.height - bottomPadding),
            CGPoint(x: self.bounds.width - rightPadding, y: self.bounds.height - bottomPadding)]
        
        CGContextAddLines(context, topLine, 2)
        CGContextAddLines(context, bottomLine, 2)
        CGContextSetStrokeColorWithColor(context, axisColor.CGColor)
        CGContextSetLineWidth(context, 1.0)
        CGContextSetShouldAntialias(context, false)
        CGContextStrokePath(context)
    }
    
    func projectPoints(points: [Point], xMin: CGFloat, yMin: CGFloat, xMax: CGFloat, yMax: CGFloat) -> [(CGFloat, CGFloat)] {
        let xRange = xMax - xMin
        let yRange = yMax - yMin
        
        var p: [(CGFloat, CGFloat)] = []
        var i = 0.0
        let xIncrement = CGFloat(xAxisLength) / CGFloat(points.count)
        
        for point in points {
//            var x = leftPadding + ((point.0 - xMin) / xRange) * xAxisLength
            let amount = CGFloat(xIncrement) * CGFloat(i)
            var x = leftPadding + amount
            var y = topPadding + (yAxisLength - (((point.value - yMin) / yRange) * yAxisLength))
            p.insert((x,y), atIndex: p.count)
            i++
        }
        
        return p
    }
    
    func drawDataPoints(context: CGContextRef, pointRadius: CGFloat, strokeColor: UIColor, fillColor: UIColor, points: [(CGFloat, CGFloat)]) {
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
        CGContextSetFillColorWithColor(context, fillColor.CGColor)
        for (x, y) in points {
            CGContextBeginPath(context)
            CGContextAddArc(context, x, y, pointRadius, 0.0, CGFloat(2.0*M_PI), 0)
            CGContextEOFillPath(context)
            CGContextStrokePath(context)
        }
    }
    
    func drawLines(strokeWidth: CGFloat, strokeColor: UIColor, points: [(CGFloat, CGFloat)]) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
        
        var firstPoint = CGPoint(x: points[0].0, y: points[0].1)
        var secondPoint = CGPoint(x: points[1].0, y: points[1].1)
        var lines = [firstPoint, secondPoint]
        
        CGContextMoveToPoint(context, points[0].0, points[0].1)
        CGContextAddLineToPoint(context, points[1].0, points[1].1)
        
        for var i = 1; i < points.count - 1; i++ {
            CGContextAddLineToPoint(context, points[i].0, points[i].1)
            CGContextAddLineToPoint(context, points[i+1].0, points[i+1].1)
        }
        
        CGContextSetLineWidth(context, strokeWidth)
        CGContextSetStrokeColorWithColor(context,strokeColor.CGColor)
        CGContextSetShouldAntialias(context, true)
        CGContextStrokePath(context)
        
        var moreLines = [lines.last!]
        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextFillPath(context)
        
        CGContextRestoreGState(context)
    }
    
    func drawLabels() {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        // X Axis
        var attributes = [NSForegroundColorAttributeName : UIColor(white: 1.0, alpha: 1.0).CGColor,
        NSFontAttributeName : UIFont.systemFontOfSize(17)]
        var xAxisLabel = NSMutableAttributedString(string:self.xAxisLabel, attributes: attributes as [NSObject : AnyObject])
        var line = CTLineCreateWithAttributedString(xAxisLabel)
        let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
        let xn = bounds.width/2
        let yn = bounds.midY
        CGContextSetTextPosition(context, xAxisLength/2 - xn + leftPadding, 0.0)
        
        CGContextTranslateCTM(context, 0.0, self.frame.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CTLineDraw(line, context);
        
        CGContextRestoreGState(context)
    }
    
    var xAxisLength: CGFloat {
        get {
            return self.bounds.width - leftPadding - rightPadding
        }
    }
    
    var yAxisLength: CGFloat {
        get {
            return self.bounds.height - topPadding - bottomPadding
        }
    }
    
    override func prepareForInterfaceBuilder() {
        var plot = Plot()
        for var i = 0.0; i < 100.0; i += 0.5 {
            var y = 8*sin(i) + 40
            var point = Point(object: i, value: CGFloat(y))
            plot.points.insert(point, atIndex: plot.points.count)
        }
//        for var i = 0.0; i < 100.0; i += 1 {
//            var y = i
//            plot.points.insert((CGFloat(i), CGFloat(y)), atIndex: plot.points.count)
//        }
        xAxisLabel = "X Axis Stuff"
        plot.strokeColor = UIColor.whiteColor()
        plot.pointRadius = 0.0
        plot.strokeWidth = 2.0
        data.append(plot)
    }
}
