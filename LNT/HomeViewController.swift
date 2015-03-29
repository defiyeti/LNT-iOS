//
//  ViewController.swift
//  LNT
//
//  Created by Henry Popp on 2/18/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.title = "Your Usage"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            var cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as UtilityCell!
            cell.utilityName = "Electricity"
            cell.yourConsumptionLabel.text = "Your Consumption\n1150 kW/hr"
            cell.localAverageLabel.text = "Local Average\n970 kW/hr"
            return cell
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as UtilityCell!
            cell.utilityName = "Water"
            cell.protoGraphView.backgroundColor = UIColor(red: 160/255.0, green: 197/255.0, blue: 249/255.0, alpha: 1.0)
            return cell
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("UtilityCell") as UtilityCell!
            cell.utilityName = "Natural Gas"
            cell.protoGraphView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
            return cell
        case 3:
            var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as ButtonCell!
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

