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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    enum Utility {
        case Electricity, Water, NaturalGas;
    }
    
    func randomData() -> [Graph.Point] {
        var points: [Graph.Point] = []
        for var i = 0.0; i < 12.0; i += 1 {
            var y = 50 + arc4random_uniform(200)
            var point = Graph.Point(object: i, value: CGFloat(y))
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
        let completion = {(stats: [Statistic]) -> () in
            println(stats.debugDescription)
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
            var cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as! UtilityCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.utilityName = "Electricity"
            cell.yourConsumptionLabel.text = "Your Consumption\n1150 kW/hr"
            cell.localAverageLabel.text = "Local Average\n970 kW/hr"
            cell.background.topColor = UIColor.leaveNoTraceYellow()
            cell.background.bottomColor = UIColor.leaveNoTraceYellow().darkerColor()
            var plot = Graph.Plot()
            plot.points = randomData()
            plot.strokeColor = UIColor.whiteColor()
            plot.pointRadius = 2.0
            plot.strokeWidth = 2.0
            cell.protoGraphView.data.append(plot)
            return cell
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as! UtilityCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.utilityName = "Water"
            cell.background.topColor = UIColor.leaveNoTraceBlue()
            cell.background.bottomColor = UIColor.leaveNoTraceBlue().darkerColor()
            var plot = Graph.Plot()
            plot.points = randomData()
            plot.strokeColor = UIColor.whiteColor()
            plot.pointRadius = 2.0
            plot.strokeWidth = 2.0
            cell.protoGraphView.data.append(plot)
            return cell
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as! UtilityCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.utilityName = "Natural Gas"
            cell.background.topColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            cell.background.bottomColor = UIColor(red: 241/255.0, green: 0/255.0, blue: 204/255.0, alpha: 1.0)
            var plot = Graph.Plot()
            plot.points = randomData()
            plot.strokeColor = UIColor.whiteColor()
            plot.pointRadius = 2.0
            plot.strokeWidth = 2.0
            cell.protoGraphView.data.append(plot)
            return cell
        case 3:
            var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0...2:
            return 300
        default:
            return 60
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

