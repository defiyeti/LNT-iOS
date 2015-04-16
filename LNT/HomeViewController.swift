//
//  ViewController.swift
//  LNT
//
//  Created by Henry Popp on 2/18/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

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
        var r = UnsafeMutablePointer<CGFloat>.alloc(1)
        var g = UnsafeMutablePointer<CGFloat>.alloc(1)
        var b = UnsafeMutablePointer<CGFloat>.alloc(1)
        var a = UnsafeMutablePointer<CGFloat>.alloc(1)
        self.getRed(r, green: g, blue: b, alpha: a)
        var darkerColor = UIColor(red: max(0.0, amount*r.memory), green: max(0.0, amount*g.memory), blue: max(0.0, amount*b.memory), alpha: a.memory)
        
        r.destroy(); g.destroy(); b.destroy(); a.destroy()
        r.dealloc(1); g.dealloc(1); b.dealloc(1); a.dealloc(1)
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

enum Utility {
    case CarbonFootprint, Electricity, Water, NaturalGas;
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var activeData: [Statistic] = []
    var electricityData: [(String, CGFloat)] = []
    var waterData: [(String, CGFloat)] = []
    var naturalGasData: [(String, CGFloat)] = []
    
    func randomData() -> [Graph.Point] {
        var points: [Graph.Point] = []
        for var i = 0.0; i < 12.0; i += 1 {
            var y = 50 + arc4random_uniform(200)
            var point = Graph.Point(object: i, value: CGFloat(y))
            points.append(point)
        }
        return points
    }
    
    func dataToPoints(data: [(String, CGFloat)]) -> [Graph.Point] {
        var points: [Graph.Point] = []
        for stat in data {
            var point = Graph.Point(object: stat.0, value: stat.1)
            points.append(point)
        }
        return points
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.title = "Your Usage"
        self.navigationController?.navigationBar.tintColor = UIColor.leaveNoTraceGreen()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let completion = {(stats: [Statistic]) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.electricityData = []
                self.waterData = []
                self.naturalGasData = []
                for stat in stats {
                    self.electricityData.append(stat.month!, CGFloat(stat.electricityUsage!))
                    self.waterData.append(stat.month!, CGFloat(stat.waterUsage!))
                    self.naturalGasData.append(stat.month!, CGFloat(stat.naturalGasUsage!))
                }
                self.tableView.reloadData()
                self.tableView.setNeedsDisplay()
            })
        }
        let email = NSUserDefaults.standardUserDefaults().stringForKey(USER_EMAIL_DEFAULTS_KEY)
        let (dictionary, error) = Locksmith.loadDataForUserAccount(email!)
        let userToken = (dictionary as NSDictionary!)[USER_TOKEN_KEY] as! String
        
        ServerManager.getStats(email, userToken: userToken, completion: completion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return utilityCell(tableView, utility: Utility.CarbonFootprint)
        case 1:
            return utilityCell(tableView, utility: Utility.Electricity)
        case 2:
            return utilityCell(tableView, utility: Utility.Water)
        case 3:
            return utilityCell(tableView, utility: Utility.NaturalGas)
        case 4:
            var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func utilityCell(tableView: UITableView, utility: Utility) -> UtilityCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as! UtilityCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var points: [Graph.Point] = []
        switch utility {
        case Utility.CarbonFootprint:
            cell.utilityName = "Carbon Footprint"
            cell.yourConsumptionLabel.text = "Your Footprint"
            cell.localAverageLabel.text = "Local Average"
            cell.background.topColor = UIColor.leaveNoTraceGreen()
            cell.background.bottomColor = UIColor.leaveNoTraceGreen().darkerColor()
            points = randomData()
        case Utility.Electricity:
            cell.utilityName = "Electricity"
            if let (_, lastData) = electricityData.last {
                cell.yourConsumptionLabel.text = "Your Consumption\n\(Int(lastData)) kW/hr"
                cell.localAverageLabel.text = "Local Average\n970 kW/hr"
            }
            cell.background.topColor = UIColor.leaveNoTraceYellow()
            cell.background.bottomColor = UIColor.leaveNoTraceYellow().darkerColor()
            points = dataToPoints(electricityData)
        case Utility.Water:
            cell.utilityName = "Water"
            if let (_, lastData) = waterData.last {
                cell.yourConsumptionLabel.text = "Your Consumption\n\(Int(lastData)) gallons"
                cell.localAverageLabel.text = "Local Average\n4000 gallons"
            }
            cell.background.topColor = UIColor.leaveNoTraceBlue()
            cell.background.bottomColor = UIColor.leaveNoTraceBlue().darkerColor()
            points = dataToPoints(waterData)
        case Utility.NaturalGas:
            cell.utilityName = "Natural Gas"
            if let (_, lastData) = naturalGasData.last {
                cell.yourConsumptionLabel.text = "Your Consumption\n\(Int(lastData)) CCF"
                cell.localAverageLabel.text = "Local Average\n50 CCF"
            }
            cell.background.topColor = UIColor.leaveNoTracePink()
            cell.background.bottomColor = UIColor.leaveNoTracePink().darkerColor()
            points = dataToPoints(naturalGasData)
        default:
            break
        }
        
        if points.count > 1 {
            var plot = Graph.Plot()
            plot.points = points
            plot.strokeColor = UIColor.whiteColor()
            plot.pointRadius = 3.0
            plot.strokeWidth = 2.0
            cell.protoGraphView.data.removeAll(keepCapacity: false)
            cell.protoGraphView.data.append(plot)
            cell.protoGraphView.yMin = minValue(points) * 0.75
            cell.protoGraphView.yMax = maxValue(points) * 1.25
            cell.protoGraphView.setNeedsDisplay()
        }
        println("\(utility.hashValue) has \(cell.protoGraphView.data.first?.points.count)")
        return cell
    }
    
    func minValue(points: [Graph.Point]) -> CGFloat {
        var min = CGFloat.max
        for point in points {
            min = point.value < min ? point.value : min
        }
        return min
    }
    
    func maxValue(points: [Graph.Point]) -> CGFloat {
        var max = CGFloat.min
        for point in points {
            max = point.value > max ? point.value : max
        }
        return max
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0...3:
            return 300
        default:
            return 60
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

