//
//  UserAuthViewController.swift
//  LNT
//
//  Created by Henry Popp on 3/27/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class UserAuthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum UserAuthViewMode {
        case Registration, Login;
    }
    
    var activeMode: UserAuthViewMode!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toggleDetail: UILabel!
    @IBOutlet var toggleButton: UIButton!
    
    override func viewDidLoad() {
        activeMode = UserAuthViewMode.Registration
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let inset:CGFloat = 10.0
        if activeMode == UserAuthViewMode.Login {
            switch indexPath.row {
            case 0:
                var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as TextFieldCell!
                cell.textField.placeholder = "Enter your username"
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                return cell
            case 1:
                var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as TextFieldCell!
                cell.textField.placeholder = "Enter your password"
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                return cell
            case 2:
                var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as ButtonCell!
                cell.button.setTitle("Log In", forState: UIControlState.Normal)
                return cell
            default:
                return UITableViewCell()
            }
        }
        else if activeMode == UserAuthViewMode.Registration {
//            if indexPath.section == 0 {
//                var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as ButtonCell!
//                cell.button.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
//                cell.button.setTitle("Log In With Facebook", forState: UIControlState.Normal)
//                return cell
//            }
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as ButtonCell!
                    cell.button.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
                    cell.button.setTitle("Log In With Facebook", forState: UIControlState.Normal)
                    return cell
                case 1:
                    var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as TextFieldCell!
                    cell.textField.placeholder = "Choose a username"
                    cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                    return cell
                case 2:
                    var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as TextFieldCell!
                    cell.textField.placeholder = "Enter your email"
                    cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                    return cell
                case 3:
                    var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as TextFieldCell!
                    cell.textField.placeholder = "Enter your password"
                    cell.textField.secureTextEntry = true
                    cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                    return cell
                case 4:
                    var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as TextFieldCell!
                    cell.textField.placeholder = "Enter your zip code"
                    cell.textField.secureTextEntry = true
                    cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                    return cell
                default:
                    return UITableViewCell()
                }
            }
            else if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    var cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as ToggleCell!
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.toggleLabel.text = "Electricity"
                    cell.toggleSwitch.onTintColor = UIColor(red: 255/255.0, green: 205/255.0, blue: 62/255.0, alpha: 1.0)
//                    cell.toggleSwitch.onTintColor = UIColor.leaveNoTraceGreen()
                    cell.background.topColor = UIColor(red: 255/255.0, green: 205/255.0, blue: 62/255.0, alpha: 1.0)
                    cell.background.bottomColor = UIColor(red: 255/255.0, green: 205/255.0, blue: 62/255.0, alpha: 1.0)
                    return cell
                case 1:
                    var cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as ToggleCell!
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.toggleLabel.text = "Water"
                    cell.toggleSwitch.onTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
//                    cell.toggleSwitch.onTintColor = UIColor.leaveNoTraceGreen()
                    cell.background.topColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
                    cell.background.bottomColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
                    return cell
                case 2:
                    var cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as ToggleCell!
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.toggleLabel.text = "Natural Gas"
                    cell.toggleSwitch.onTintColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
//                    cell.toggleSwitch.onTintColor = UIColor.leaveNoTraceGreen()
                    cell.background.topColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
                    cell.background.bottomColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
                    return cell
                default:
                    return UITableViewCell()
                }
            }
            else if indexPath.section == 2 {
                var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as ButtonCell!
                cell.button.setTitle("Sign Up", forState: UIControlState.Normal)
                cell.button.backgroundColor = UIColor.leaveNoTraceGreen()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRegistrationMode() {
            switch section {
            case 0:
                return 5
            case 1:
                return 3
            case 2:
                return 1
            default:
                return 0
            }
        }
        else if isLoginMode() {
            return 3
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["Create an Account", "What utilities do you use?", ""]
        return titles[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return isRegistrationMode() ? 3 : 1
    }
    
    func isRegistrationMode() -> Bool {
        return activeMode == UserAuthViewMode.Registration
    }
    
    func isLoginMode() -> Bool {
        return activeMode == UserAuthViewMode.Registration
    }
    
    func setRegistrationMode() {
        activeMode = UserAuthViewMode.Registration
        toggleDetail.text = "Already have an account?"
        toggleButton.setTitle("Log In", forState: UIControlState.Normal)
    }
    
    func setLoginMode() {
        activeMode = UserAuthViewMode.Login
        toggleDetail.text = "Don't have an account?"
        toggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
    }
    
    @IBAction func toggleAuthModeButtonPressed(sender: AnyObject) {
        isLoginMode() ? setRegistrationMode() : setLoginMode()
        tableView.reloadData()
    }
    
}