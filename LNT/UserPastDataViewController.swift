//
//  UserPastDataViewController.swift
//  LNT
//
//  Created by Henry Popp on 4/23/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class UserPastDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var currentUser: User?
    
    let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ServerManager.getUserDetails { (user) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.currentUser = user
                self.tableView.reloadData()
            })
        }
    }
    
    func multilineCell(tableView: UITableView, stat: Statistic) -> MultilineCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MultilineCell") as! MultilineCell
        cell.title = "\(months[stat.month]), \(stat.year)"
        if stat.electricityUsage != nil {
            cell.textOne = "Electricity Usage: \(stat.electricityUsage!) kW/hr"
        }
        else {
            cell.textOne = "Electricity Usage: n/a"
        }
        if stat.waterUsage != nil {
            cell.textTwo = "Water Usage: \(stat.waterUsage!) Gallons"
        }
        else {
            cell.textTwo = "Water Usage: n/a"
        }
        if stat.naturalGasUsage != nil {
            cell.textThree = "Natural Gas Usage: \(stat.naturalGasUsage!) CCF"
        }
        else {
            cell.textThree = "Natural Gas Usage: n/a"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if currentUser != nil {
            return multilineCell(tableView, stat: currentUser!.stats[indexPath.row])
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var stat = currentUser?.stats[indexPath.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditPastDataSegue" {
            var stat = currentUser!.stats[tableView.indexPathForSelectedRow()!.row]
            var statInputVC = segue.destinationViewController as! StatInputViewController
            statInputVC.usesElectricity = currentUser!.usesElectricity
            statInputVC.usesWater = currentUser!.usesWater
            statInputVC.usesNaturalGas = currentUser!.usesNaturalGas
            
            statInputVC.electricityUsage = stat.electricityUsage!
            statInputVC.waterUsage = stat.waterUsage!
            statInputVC.naturalGasUsage = stat.naturalGasUsage!
            
            statInputVC.month = stat.month
            statInputVC.year = stat.year
            
            statInputVC.allowsDateEdit = false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser?.stats != nil ? currentUser!.stats.count : 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 106
    }
}