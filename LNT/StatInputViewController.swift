//
//  StatInputViewController.swift
//  LNT
//
//  Created by Henry Popp on 3/31/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class StatInputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ButtonCellDelegate, MonthYearPickerCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var electricityUsage: Int?
    var waterUsage: Int?
    var naturalGasUsage: Int?
    var month: Int?
    var year: Int?
    
    var usesElectricity = true
    var usesWater = true
    var usesNaturalGas = true
    var allowsDateEdit = true
    
    let ELECTRICITY_TAG = 100
    let WATER_TAG = 101
    let NATURAL_GAS_TAG = 102
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if allowsDateEdit {
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let monthComponents = calendar.components(.Month, fromDate: date)
            let yearComponents = calendar.components(.Year, fromDate: date)
            month = monthComponents.month-1
            year = yearComponents.year
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = utilityInputCell(tableView, utility: Utility.Electricity) as TextFieldCell
                cell.textField.tag = ELECTRICITY_TAG
                cell.textField.delegate = self
                if electricityUsage != nil {
                    cell.textField.placeholder = "\(electricityUsage!)"
                }
                cell.textField.addTarget(self, action: "textChanged:", forControlEvents: UIControlEvents.EditingChanged)
                return cell
            case 1:
                let cell = utilityInputCell(tableView, utility: Utility.Water) as TextFieldCell
                cell.textField.tag = WATER_TAG
                cell.textField.delegate = self
                if waterUsage != nil {
                    cell.textField.placeholder = "\(waterUsage!)"
                }
                cell.textField.addTarget(self, action: "textChanged:", forControlEvents: UIControlEvents.EditingChanged)
                return cell
            case 2:
                let cell = utilityInputCell(tableView, utility: Utility.NaturalGas) as TextFieldCell
                cell.textField.tag = NATURAL_GAS_TAG
                cell.textField.delegate = self
                if naturalGasUsage != nil {
                    cell.textField.placeholder = "\(naturalGasUsage!)"
                }
                cell.textField.addTarget(self, action: "textChanged:", forControlEvents: UIControlEvents.EditingChanged)
                return cell
            case 3:
                let cell = tableView.dequeueReusableCellWithIdentifier("PickerCell") as! MonthYearPickerCell
                cell.select(month!, year: year!)
                cell.delegate = self
                cell.hidden = !allowsDateEdit
                return cell
            default:
                return UITableViewCell()
            }
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
            cell.title = "Submit"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            cell.loadingIndicator.hidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func utilityInputCell(tableView: UITableView, utility: Utility) -> TextFieldCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
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
            return usesElectricity ? 80 : 0
        case NSIndexPath(forRow: 1, inSection: 0):
            return usesWater ? 80 : 0
        case NSIndexPath(forRow: 2, inSection: 0):
            return usesNaturalGas ? 80 : 0
        case NSIndexPath(forRow: 3, inSection: 0):
            return allowsDateEdit ? 175 : 0
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
    
    func textChanged(textField: UITextField) {
        switch textField.tag {
        case ELECTRICITY_TAG:
            electricityUsage = textField.text.isEmpty ? Int(textField.placeholder?) : Int(textField.text)!
        case WATER_TAG:
            waterUsage = textField.text.isEmpty ? Int(textField.placeholder?) : Int(textField.text)!
        case NATURAL_GAS_TAG:
            naturalGasUsage = textField.text.isEmpty ? Int(textField.placeholder?) : Int(textField.text)!
        default:
            break
        }
    }
    
    func didChangeDate(pickerCell: MonthYearPickerCell, month: Int, year: Int) {
        self.month = month
        self.year = year
    }
    
    func didPressButtonCell(buttonCell: ButtonCell) {
        let stat = Statistic(electricityUsage: electricityUsage, waterUsage: waterUsage, naturalGasUsage: naturalGasUsage, carbonFootprint: nil, month: month, year: year)
        buttonCell.startLoading()
        ServerManager.postStats(stat, completion: { (error: NSError?) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error == nil {
                    buttonCell.stopLoading()
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    buttonCell.stopLoading()
                    let alertView = UIAlertView(title: "Error", message: "Network connection failed. Please try again.", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            })
        })
    }
}