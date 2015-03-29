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
            switch indexPath.row {
            case 0:
                var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as TextFieldCell!
                cell.textField.placeholder = "Choose a username"
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                return cell
            case 1:
                var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as TextFieldCell!
                cell.textField.placeholder = "Enter your email"
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                return cell
            case 2:
                var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as TextFieldCell!
                cell.textField.placeholder = "Enter your password"
                cell.textField.secureTextEntry = true
                cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                return cell
            case 3:
                var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as ButtonCell!
                cell.button.setTitle("Sign Up", forState: UIControlState.Normal)

                return cell
            default:
                return UITableViewCell()
            }
        }
        else {
            //nothing
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch activeMode.hashValue {
        case UserAuthViewMode.Registration.hashValue:
            return 4
        case UserAuthViewMode.Login.hashValue:
            return 3
        default:
            return 0
        }
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
        activeMode == UserAuthViewMode.Login ? setRegistrationMode() : setLoginMode()
        tableView.reloadData()
    }
    
}