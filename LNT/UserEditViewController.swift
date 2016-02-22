//
//  UserEditViewController.swift
//  LNT
//
//  Created by Henry Popp on 4/10/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class UserEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonCellDelegate, ToggleCellDelegate, UITextFieldDelegate {
    @IBOutlet var tableView: UITableView!
    var currentUser: User?
    var email = ""
    var password = ""
    var zipCode = ""
    var usesElectricity = true
    var usesWater = true
    var usesNaturalGas = true
    
    let EMAIL_TAG = 100
    let PASSWORD_TAG = 101
    let ZIPCODE_TAG = 102
    
    let ELECTRICITY_TAG = 103
    let WATER_TAG = 104
    let NATURAL_GAS_TAG = 105
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.title = "Account Settings"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        email = NSUserDefaults.standardUserDefaults().objectForKey(USER_EMAIL_DEFAULTS_KEY) as! String
        ServerManager.getUserDetails { (user) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.currentUser = user
                self.zipCode = user.zipcode!
                self.usesElectricity = user.usesElectricity
                self.usesWater = user.usesWater
                self.usesNaturalGas = user.usesNaturalGas
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let inset:CGFloat = 10.0
        if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
                cell.button.setTitle("Log Out", forState: UIControlState.Normal)
                cell.button.backgroundColor = UIColor.leaveNoTracePink()
                cell.title = "Log Out"
                cell.delegate = self
                cell.loadingIndicator.hidden = true
                return cell
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                cell.textField.placeholder = "Change your email"
                cell.textField.delegate = self
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                cell.textField.addTarget(self, action: "textChanged:", forControlEvents: UIControlEvents.EditingChanged)
                let email = NSUserDefaults.standardUserDefaults().objectForKey(USER_EMAIL_DEFAULTS_KEY) as! String
                cell.textField.text = email
                cell.textField.tag = EMAIL_TAG
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                cell.textField.placeholder = "Change your password"
                cell.textField.secureTextEntry = true
                cell.textField.delegate = self
                cell.textField.addTarget(self, action: "textChanged:", forControlEvents: UIControlEvents.EditingChanged)
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                cell.textField.tag = PASSWORD_TAG
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                cell.textField.placeholder = "Change your zipcode"
                cell.textField.keyboardType = UIKeyboardType.NumberPad
                cell.textField.secureTextEntry = false
                cell.textField.delegate = self
                cell.textField.addTarget(self, action: "textChanged:", forControlEvents: UIControlEvents.EditingChanged)
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                cell.textField.tag = ZIPCODE_TAG
                return cell
            case 3:
                let cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as! ToggleCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.toggleLabel.text = "Electricity"
                cell.toggleSwitch.onTintColor = UIColor.leaveNoTraceYellow().lighterColor()
                cell.background.topColor = UIColor.leaveNoTraceYellow()
                cell.background.bottomColor = UIColor.leaveNoTraceYellow()
                if currentUser != nil {
                    cell.toggle(usesElectricity, animated: false)
                }
                cell.tag = ELECTRICITY_TAG
                cell.delegate = self
                return cell
            case 4:
                let cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as! ToggleCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.toggleLabel.text = "Water"
                cell.toggleSwitch.onTintColor = UIColor.leaveNoTraceBlue().lighterColor()
                cell.background.topColor = UIColor.leaveNoTraceBlue()
                cell.background.bottomColor = UIColor.leaveNoTraceBlue()
                if currentUser != nil {
                    cell.toggle(usesWater, animated: false)
                }
                cell.tag = WATER_TAG
                cell.delegate = self
                return cell
            case 5:
                let cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as! ToggleCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.toggleLabel.text = "Natural Gas"
                cell.toggleSwitch.onTintColor = UIColor(white: 1.0, alpha: 0.5)
                cell.background.topColor = UIColor.leaveNoTracePink()
                cell.background.bottomColor = UIColor.leaveNoTracePink()
                if currentUser != nil {
                    cell.toggle(usesNaturalGas, animated: false)
                }
                cell.tag = NATURAL_GAS_TAG
                cell.delegate = self
                return cell
            case 6:
                let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
                cell.button.setTitle("Update Account", forState: UIControlState.Normal)
                cell.button.backgroundColor = UIColor.leaveNoTraceGreen()
                cell.title = "Update Account"
                cell.delegate = self
                cell.loadingIndicator.hidden = true
                return cell
            default:
                return UITableViewCell()
            }
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
            cell.button.setTitle("Edit Past Data", forState: UIControlState.Normal)
            cell.button.backgroundColor = UIColor.leaveNoTraceGreen()
            cell.title = "Edit Past Data"
            cell.delegate = self
            cell.loadingIndicator.hidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func textChanged(textField: UITextField) {
        switch textField.tag {
        case EMAIL_TAG:
            email = textField.text!
        case PASSWORD_TAG:
            password = textField.text!
        case ZIPCODE_TAG:
            zipCode = textField.text!
        default:
            break
        }
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
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ToggleCell {
            cell.toggle(!cell.on(), animated: true)
        }
    }
    
    func didPressButtonCell(buttonCell: ButtonCell) {
        switch buttonCell.title {
        case "Log Out":
            logOut()
        case "Edit Past Data":
            self.performSegueWithIdentifier("UserPastDataSegue", sender: nil)
        case "Update Account":
            buttonCell.startLoading()
            ServerManager.updateUser(currentUser!.id!, email: email, password: password, zipCode: zipCode, usesElectricity: usesElectricity, usesWater: usesWater, usesNaturalGas: usesNaturalGas, completion: { (error) -> () in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if error == nil {
                            buttonCell.stopLoading()
                            displayElectricity = self.usesElectricity
                            displayWater = self.usesWater
                            displayNaturalGas = self.usesNaturalGas
                        }
                        else {
                            buttonCell.stopLoading()
                            let alertView = UIAlertView(title: "Error", message: "Network connection failed. Please try again.", delegate: nil, cancelButtonTitle: "OK")
                            alertView.show()
                        }
                    })
                })
        default:
            break
        }
    }
    
    func didToggleCell(toggleCell: ToggleCell, on: Bool) {
        switch toggleCell.tag {
        case ELECTRICITY_TAG:
            usesElectricity = on
        case WATER_TAG:
            usesWater = on
        case NATURAL_GAS_TAG:
            usesNaturalGas = on
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "UserPastDataSegue" {
            let pastDataVC = segue.destinationViewController as! UserPastDataViewController
            pastDataVC.currentUser = currentUser
        }
    }
    
    func logOut() {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: USER_EMAIL_DEFAULTS_KEY)
        
        let appDelegateTemp = UIApplication.sharedApplication().delegate
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rootController = storyboard.instantiateViewControllerWithIdentifier("UserAuthViewController") 
        let navigation = UINavigationController(rootViewController: rootController)
        appDelegateTemp?.window??.rootViewController = navigation
    }
}
