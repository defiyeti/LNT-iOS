//
//  StatInputViewController.swift
//  LNT
//
//  Created by Henry Popp on 3/31/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class StatInputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return utilityInputCell(tableView, utility: Utility.Electricity)
            case 1:
                return utilityInputCell(tableView, utility: Utility.Water)
            case 2:
                return utilityInputCell(tableView, utility: Utility.NaturalGas)
            case 3:
                var cell = tableView.dequeueReusableCellWithIdentifier("PickerCell") as! MonthYearPickerCell
                return cell
            default:
                return UITableViewCell()
            }
        }
        else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        return UITableViewCell()
    }
    
    func utilityInputCell(tableView: UITableView, utility: Utility) -> TextFieldCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        switch utility {
        case Utility.Electricity:
            cell.label.text = "Electricity"
            cell.gradientView.topColor = UIColor.leaveNoTraceYellow()
            cell.gradientView.bottomColor = UIColor.leaveNoTraceYellow().darkerColor()
        case Utility.Water:
            cell.label.text = "Water"
            cell.gradientView.topColor = UIColor.leaveNoTraceBlue()
            cell.gradientView.bottomColor = UIColor.leaveNoTraceBlue().darkerColor()
        case Utility.NaturalGas:
            cell.label.text = "Natural Gas"
            cell.gradientView.topColor = UIColor.leaveNoTracePink()
            cell.gradientView.bottomColor = UIColor.leaveNoTracePink().darkerColor()
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath {
        case NSIndexPath(forRow: 0, inSection: 0):
            return 80
        case NSIndexPath(forRow: 1, inSection: 0):
            return 80
        case NSIndexPath(forRow: 2, inSection: 0):
            return 80
        case NSIndexPath(forRow: 3, inSection: 0):
            return 175
        case NSIndexPath(forRow: 0, inSection: 1):
            return 60
        default:
            return 60
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
}