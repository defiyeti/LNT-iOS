//
//  ViewController.swift
//  LNT
//
//  Created by Henry Popp on 2/18/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import UIKit

enum Utility {
    case CarbonFootprint, Electricity, Water, NaturalGas;
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var activeData: [Statistic] = []
    var electricityData: [(Int, CGFloat)] = []
    var waterData: [(Int, CGFloat)] = []
    var naturalGasData: [(Int, CGFloat)] = []
    var carbonFootprintData: [(Int, CGFloat)] = []
    
    var electricityAvg = 0
    var electricityUserAvg = 0
    var electricityPercentile: Float = 0.0
    
    var waterAvg = 0
    var waterUserAvg = 0
    var waterPercentile: Float = 0.0
    
    var naturalGasAvg = 0
    var naturalGasUserAvg = 0
    var naturalGasPercentile: Float = 0.0
    
    var carbonFootprintAvg = 0
    var carbonFootprintUserAvg = 0
    var carbonFootprintPercentile: Float = 0.0
    
    var selectedUtility: Utility = Utility.Electricity
    
    var utilityCellHeights: [Utility:CGFloat] = [Utility.Electricity: 300, Utility.Water: 300, Utility.NaturalGas: 300, Utility.CarbonFootprint: 300]
    
    func randomData() -> [Graph.Point] {
        var points: [Graph.Point] = []
        for var i = 0.0; i < 12.0; i += 1 {
            var y = 50 + arc4random_uniform(200)
            var point = Graph.Point(object: i, value: CGFloat(y))
            points.append(point)
        }
        return points
    }
    
    func dataToPoints(data: [(Int, CGFloat)]) -> [Graph.Point] {
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
        let completion = {(stats: [Statistic], electricityRanking: [String:AnyObject], waterRanking: [String:AnyObject], naturalGasRanking: [String:AnyObject], carbonFootprintRanking: [String:AnyObject]) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.electricityData = []
                self.waterData = []
                self.naturalGasData = []
                self.carbonFootprintData = []
                for stat in stats {
                    self.electricityData.append(stat.month!, CGFloat(stat.electricityUsage!))
                    self.waterData.append(stat.month!, CGFloat(stat.waterUsage!))
                    self.naturalGasData.append(stat.month!, CGFloat(stat.naturalGasUsage!))
                    self.carbonFootprintData.append(stat.month!, CGFloat(stat.carbonFootprint!))
                }
                self.electricityAvg = electricityRanking["average"] as! Int
                self.electricityUserAvg = electricityRanking["your_average"] as! Int
                self.electricityPercentile = electricityRanking["percentile"] as! Float
                
                self.waterAvg = waterRanking["average"] as! Int
                self.waterUserAvg = waterRanking["your_average"] as! Int
                self.waterPercentile = waterRanking["percentile"] as! Float
                
                self.naturalGasAvg = naturalGasRanking["average"] as! Int
                self.naturalGasUserAvg = naturalGasRanking["your_average"] as! Int
                self.naturalGasPercentile = naturalGasRanking["percentile"] as! Float
                
                self.carbonFootprintAvg = carbonFootprintRanking["average"] as! Int
                self.carbonFootprintUserAvg = carbonFootprintRanking["your_average"] as! Int
                self.carbonFootprintPercentile = carbonFootprintRanking["percentile"] as! Float
                
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
            var cell = utilityCell(tableView, utility: Utility.CarbonFootprint)
            return cell
        case 1:
            var cell = utilityCell(tableView, utility: Utility.Electricity)
            return cell
        case 2:
            return reduceUsageCell(tableView, utility: Utility.Electricity)
        case 3:
            var cell = utilityCell(tableView, utility: Utility.Water)
            return cell
        case 4:
            return reduceUsageCell(tableView, utility: Utility.Water)
        case 5:
            var cell = utilityCell(tableView, utility: Utility.NaturalGas)
            return cell
        case 6:
            return reduceUsageCell(tableView, utility: Utility.NaturalGas)
        case 7:
            var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Gotta call this or else the utility cell colors go all whack
        (cell as? UtilityCell)?.background.setNeedsDisplay()
    }
    
    func reduceUsageCell(tableView: UITableView, utility: Utility) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ReduceUsageCell") as! UITableViewCell
        var limit = 0.5 as Float
        var shouldHide = true
        var utilityString = ""
        switch utility {
        case Utility.Electricity:
            utilityString = "electricity"
            shouldHide = electricityPercentile < limit
        case Utility.Water:
            utilityString = "water"
            shouldHide = waterPercentile < limit
        case Utility.NaturalGas:
            utilityString = "natural gas"
            shouldHide = naturalGasPercentile < limit
        default:
            break
        }
        cell.textLabel?.text = "Looks like your \(utilityString) usage is high!"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.hidden = shouldHide
        return cell
    }
    
    func percentileString(percentile: Float) -> String {
        let rank = Int(round(percentile * 100))
        let ones = rank % 10
        let tens = (rank / 10) % 10
        var str = ""
        if ones == 1 && tens != 1 {
            str = "st"
        }
        else if ones == 2 && tens != 1 {
            str = "nd"
        }
        else if ones == 3 && tens != 1 {
            str = "rd"
        }
        else {
            str = "th"
        }
        return "\(rank)\(str) Percentile"
    }
    
    func utilityCell(tableView: UITableView, utility: Utility) -> UtilityCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as! UtilityCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var points: [Graph.Point] = []
        switch utility {
        case Utility.CarbonFootprint:
            cell.utilityName = "Carbon Footprint"
            if let (_, lastData) = electricityData.last {
                cell.yourConsumptionLabel.text = "Your Average Consumption\n\(carbonFootprintUserAvg) kg CO2 (\(percentileString(carbonFootprintPercentile)))"
                cell.localAverageLabel.text = "Local Average\n\(carbonFootprintAvg) kg CO2"
            }
            cell.background.topColor = UIColor.leaveNoTraceGreen()
            cell.background.bottomColor = UIColor.leaveNoTraceGreen().darkerColor()
            cell.protoGraphView.yMiddle = CGFloat(carbonFootprintUserAvg)
            points = dataToPoints(carbonFootprintData)
        case Utility.Electricity:
            cell.utilityName = "Electricity"
            if let (_, lastData) = electricityData.last {
                cell.yourConsumptionLabel.text = "Your Average Consumption\n\(electricityUserAvg) kW/hr (\(percentileString(electricityPercentile)))"
                cell.localAverageLabel.text = "Local Average\n\(electricityAvg) kW/hr"
            }
            cell.background.topColor = UIColor.leaveNoTraceYellow()
            cell.background.bottomColor = UIColor.leaveNoTraceYellow().darkerColor()
            cell.protoGraphView.yMiddle = CGFloat(electricityAvg)
            points = dataToPoints(electricityData)
        case Utility.Water:
            cell.utilityName = "Water"
            if let (_, lastData) = waterData.last {
                cell.yourConsumptionLabel.text = "Your Average Consumption\n\(waterUserAvg) gallons (\(percentileString(waterPercentile)))"
                cell.localAverageLabel.text = "Local Average\n\(waterAvg) gallons"
            }
            cell.background.topColor = UIColor.leaveNoTraceBlue()
            cell.background.bottomColor = UIColor.leaveNoTraceBlue().darkerColor()
            cell.protoGraphView.yMiddle = CGFloat(waterAvg)
            points = dataToPoints(waterData)
        case Utility.NaturalGas:
            cell.utilityName = "Natural Gas"
            if let (_, lastData) = naturalGasData.last {
                cell.yourConsumptionLabel.text = "Your Average Consumption\n\(naturalGasUserAvg) CCF (\(percentileString(naturalGasPercentile)))"
                cell.localAverageLabel.text = "Local Average\n\(naturalGasAvg) CCF"
            }
            cell.background.topColor = UIColor.leaveNoTracePink()
            cell.background.bottomColor = UIColor.leaveNoTracePink().darkerColor()
            cell.protoGraphView.yMiddle = CGFloat(naturalGasAvg)
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
            cell.protoGraphView.hidden = false
            utilityCellHeights[utility] = 300
            cell.protoGraphView.setNeedsDisplay()
            cell.background.setNeedsDisplay()
        }
        else {
            cell.protoGraphView.hidden = true
            utilityCellHeights[utility] = 180
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 2:
            selectedUtility = Utility.Electricity
        case 4:
            selectedUtility = Utility.Water
        case 6:
            selectedUtility = Utility.NaturalGas
        default:
            break
        }
        performSegueWithIdentifier("ShowTipsSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "ShowTipsSegue" {
            var tipsVC = segue.destinationViewController as! TipsViewController
            tipsVC.activeUtility = selectedUtility
        }
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
        case 0:
            return utilityCellHeights[Utility.CarbonFootprint]!
        case 1:
            return utilityCellHeights[Utility.Electricity]!
        case 2:
            return electricityPercentile > 0.5 ? 60 : 0
        case 3:
            return utilityCellHeights[Utility.Water]!
        case 4:
            return waterPercentile > 0.5 ? 60 : 0
        case 5:
            return utilityCellHeights[Utility.NaturalGas]!
        case 6:
            return naturalGasPercentile > 0.5 ? 60 : 0
        default:
            return 60
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

