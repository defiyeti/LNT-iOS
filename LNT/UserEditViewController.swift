//
//  UserEditViewController.swift
//  LNT
//
//  Created by Henry Popp on 4/10/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class UserEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonCellDelegate, UITextFieldDelegate {
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.title = "Account Settings"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let inset:CGFloat = 10.0
        if indexPath.section == 0 {
                var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
                cell.button.setTitle("Log Out", forState: UIControlState.Normal)
                cell.button.backgroundColor = UIColor.leaveNoTracePink()
                cell.title = "Log Out"
                cell.delegate = self
                return cell
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                cell.textField.placeholder = EMAIL_PROMPT
                cell.textField.delegate = self
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                
                let email = NSUserDefaults.standardUserDefaults().objectForKey(USER_EMAIL_DEFAULTS_KEY) as! String
                cell.textField.text = email
                return cell
            case 1:
                var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                cell.textField.placeholder = PASSWORD_PROMT
                cell.textField.secureTextEntry = true
                cell.textField.delegate = self
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                return cell
            case 2:
                var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                cell.textField.placeholder = ZIPCODE_PROMPT
                cell.textField.keyboardType = UIKeyboardType.NumberPad
                cell.textField.secureTextEntry = false
                cell.textField.delegate = self
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                return cell
            case 3:
                var cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as! ToggleCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.toggleLabel.text = "Electricity"
                cell.toggleSwitch.onTintColor = UIColor.leaveNoTraceYellow().lighterColor()
                cell.background.topColor = UIColor.leaveNoTraceYellow()
                cell.background.bottomColor = UIColor.leaveNoTraceYellow()
                return cell
            case 4:
                var cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as! ToggleCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.toggleLabel.text = "Water"
                cell.toggleSwitch.onTintColor = UIColor.leaveNoTraceBlue().lighterColor()
                cell.background.topColor = UIColor.leaveNoTraceBlue()
                cell.background.bottomColor = UIColor.leaveNoTraceBlue()
                return cell
            case 5:
                var cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as! ToggleCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.toggleLabel.text = "Natural Gas"
                cell.toggleSwitch.onTintColor = UIColor(white: 1.0, alpha: 0.5)
                cell.background.topColor = UIColor.leaveNoTracePink()
                cell.background.bottomColor = UIColor.leaveNoTracePink()
                return cell
            case 6:
                var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
                cell.button.setTitle("Update Account", forState: UIControlState.Normal)
                cell.button.backgroundColor = UIColor.leaveNoTraceGreen()
                cell.title = "Update Account"
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
            }
        }
        else if indexPath.section == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
            cell.button.setTitle("Edit Past Data", forState: UIControlState.Normal)
            cell.button.backgroundColor = UIColor.leaveNoTraceGreen()
            cell.title = "Edit Past Data"
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 7
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["", "Edit Account Details", ""]
        return titles[section]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if var cell = tableView.cellForRowAtIndexPath(indexPath) as? ToggleCell {
            cell.toggle(!cell.on(), animated: true)
        }
    }
    
    func didPressButtonCell(buttonCell: ButtonCell) {
        logOut()
    }
    
    func logOut() {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: USER_EMAIL_DEFAULTS_KEY)
        
        let appDelegateTemp = UIApplication.sharedApplication().delegate
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var rootController = storyboard.instantiateViewControllerWithIdentifier("UserAuthViewController") as! UIViewController
        var navigation = UINavigationController(rootViewController: rootController)
        appDelegateTemp?.window??.rootViewController = navigation
    }
}
