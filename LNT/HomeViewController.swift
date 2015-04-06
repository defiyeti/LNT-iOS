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
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            var cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as UtilityCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.utilityName = "Electricity"
            cell.yourConsumptionLabel.text = "Your Consumption\n1150 kW/hr"
            cell.localAverageLabel.text = "Local Average\n970 kW/hr"
            cell.background.topColor = UIColor(red: 255/255.0, green: 205/255.0, blue: 62/255.0, alpha: 1.0)
            cell.background.bottomColor = UIColor(red: 255/255.0, green: 205/255.0, blue: 0/255.0, alpha: 1.0)

            return cell
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as UtilityCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.utilityName = "Water"
            cell.background.topColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
            cell.background.bottomColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0)
            return cell
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as UtilityCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.utilityName = "Natural Gas"
            cell.background.topColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            cell.background.bottomColor = UIColor(red: 241/255.0, green: 0/255.0, blue: 204/255.0, alpha: 1.0)
            return cell
        case 3:
            var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as ButtonCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0...2:
            return 250
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

