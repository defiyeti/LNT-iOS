//
//  UserAuthViewController.swift
//  LNT
//
//  Created by Henry Popp on 3/27/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

let LNT_URL = "http://45.55.129.205"
let USER_TOKEN_KEY = "user_token"
let USER_EMAIL_DEFAULTS_KEY = "UserLoginEmail"

let EMAIL_PROMPT = "Enter your email"
let PASSWORD_PROMT = "Enter your password"
let ZIPCODE_PROMPT = "Enter your zip code"

class UserAuthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonCellDelegate, ToggleCellDelegate, UITextFieldDelegate {
    
    enum UserAuthViewMode {
        case Registration, Login;
    }
    
    var activeMode: UserAuthViewMode = UserAuthViewMode.Registration
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toggleDetail: UILabel!
    @IBOutlet var toggleButton: UIButton!
    
    var email: String = ""
    var password: String = ""
    var zipCode: String = ""
    
    var usesElectricity = true
    var usesWater = true
    var usesNaturalGas = true
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setRegistrationMode()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setHomeViewControllerToRoot", name: UserDidLoginNotification, object: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let inset:CGFloat = 10.0
        
        if activeMode == UserAuthViewMode.Login {
            return cellForLoginSection(tableView, row: indexPath.row)
        }
        else if activeMode == UserAuthViewMode.Registration {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                    cell.textField.placeholder = EMAIL_PROMPT
                    cell.textField.delegate = self
                    cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                case 1:
                    var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                    cell.textField.placeholder = PASSWORD_PROMT
                    cell.textField.secureTextEntry = true
                    cell.textField.delegate = self
                    cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                case 2:
                    var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
                    cell.textField.placeholder = ZIPCODE_PROMPT
                    cell.textField.keyboardType = UIKeyboardType.NumberPad
                    cell.textField.secureTextEntry = false
                    cell.textField.delegate = self
                    cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                default:
                    return UITableViewCell()
                }
            }
            else if indexPath.section == 1 {
                var cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell") as! ToggleCell
                switch indexPath.row {
                case 0:
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.toggleLabel.text = "Electricity"
                    cell.toggleSwitch.onTintColor = UIColor.leaveNoTraceYellow().lighterColor()
                    cell.background.topColor = UIColor.leaveNoTraceYellow()
                    cell.background.bottomColor = UIColor.leaveNoTraceYellow()
                    cell.delegate = self
                case 1:
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.toggleLabel.text = "Water"
                    cell.toggleSwitch.onTintColor = UIColor.leaveNoTraceBlue().lighterColor()
                    cell.background.topColor = UIColor.leaveNoTraceBlue()
                    cell.background.bottomColor = UIColor.leaveNoTraceBlue()
                    cell.delegate = self
                case 2:
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.toggleLabel.text = "Natural Gas"
                    cell.toggleSwitch.onTintColor = UIColor(white: 1.0, alpha: 0.5)
                    cell.background.topColor = UIColor.leaveNoTracePink()
                    cell.background.bottomColor = UIColor.leaveNoTracePink()
                    cell.delegate = self
                default:
                    return UITableViewCell()
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
            else if indexPath.section == 2 {
                return signUpButtonCell(tableView)
            }
        }
        return UITableViewCell()
    }
    
    func cellForLoginSection(tableView: UITableView, row: Int) -> UITableViewCell {
        let inset:CGFloat = 10.0
        
        switch row {
        case 0:
            var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
            cell.textField.placeholder = EMAIL_PROMPT
            cell.textField.secureTextEntry = false
            cell.textField.delegate = self
            cell.textField.addTarget(self, action: "textChanged:", forControlEvents: UIControlEvents.EditingChanged)
            cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
            cell.textField.placeholder = PASSWORD_PROMT
            cell.textField.secureTextEntry = true
            cell.textField.returnKeyType = UIReturnKeyType.Go
            cell.textField.delegate = self
            cell.textField.addTarget(self, action: "textChanged:", forControlEvents: UIControlEvents.EditingChanged)
            cell.textField.layer.sublayerTransform = CATransform3DMakeTranslation(inset, 0, 0)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
            cell.button.setTitle("Log In", forState: UIControlState.Normal)
            cell.title = "Log In"
            cell.button.backgroundColor = UIColor.leaveNoTraceGreen()
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func signUpButtonCell(tableView: UITableView!) -> ButtonCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.button.setTitle("Sign Up", forState: UIControlState.Normal)
        cell.button.backgroundColor = UIColor.leaveNoTraceGreen()
        cell.title = "Sign Up"
        cell.delegate = self
        return cell
    }
    
    func facebookButtonCell(tableView: UITableView!) -> ButtonCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.button.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
        cell.button.setTitle("Log In With Facebook", forState: UIControlState.Normal)
        cell.title = "Facebook"
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRegistrationMode() {
            switch section {
            case 0:
                return 3
            case 1:
                return 3
            case 2:
                return 1
            default:
                return 0
            }
        }
        else if activeMode == UserAuthViewMode.Login {
            return 3
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if var cell = tableView.cellForRowAtIndexPath(indexPath) as? ToggleCell {
            cell.toggle(!cell.on(), animated: true)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if activeMode == UserAuthViewMode.Registration {
            let titles = ["Create an Account", "What utilities do you use?", ""]
            return titles[section]
        }
        return ""
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
        self.title = "Sign Up"
    }
    
    func setLoginMode() {
        activeMode = UserAuthViewMode.Login
        toggleDetail.text = "Don't have an account?"
        toggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
        self.title = "Log In"
    }
    
    @IBAction func textFieldValueChanged(sender: AnyObject) {
        let textField = sender as! UITextField
        switch textField.placeholder! {
        case EMAIL_PROMPT:
            email = textField.text
        case PASSWORD_PROMT:
            password = textField.text
        case ZIPCODE_PROMPT:
            zipCode = textField.text
        default:
            break
        }
    }
    
    func textChanged(textField: UITextField) {
        switch textField.placeholder! {
        case EMAIL_PROMPT:
            email = textField.text
        case PASSWORD_PROMT:
            password = textField.text
        case ZIPCODE_PROMPT:
            zipCode = textField.text
        default:
            break
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        switch textField.placeholder! {
        case EMAIL_PROMPT:
            email = textField.text
        case PASSWORD_PROMT:
            password = textField.text
        case ZIPCODE_PROMPT:
            zipCode = textField.text
        default:
            break
        }
        return true
    }
    
    func signUp() {
        if self.email.isEmpty || !isValidEmail(self.email){
            alertValidEmail()
        }
        else if self.password.isEmpty {
            alertValidPassword()
        }
        else if self.zipCode.isEmpty || !isValidZipcode(self.zipCode){
            alertValidZipcode()
        }
        else {
            request(.GET, "\(LNT_URL)/users/sign_up", parameters: nil).responseString { (request, response, json, error) -> Void in
                let csrfToken = response?.allHeaderFields["X-Csrf-Token"] as! String
                ServerManager.signUp(csrfToken, email: self.email, password: self.password, zipcode: self.zipCode, usesElectricity: self.usesElectricity, usesWater: self.usesWater, usesNaturalGas: self.usesNaturalGas)
            }
        }
    }
    
    func isValidZipcode(testStr: String) -> Bool {
        let zipcodeRegex = "^[0-9]{5}(-[0-9]{4})?"
        
        let zipcodeTest = NSPredicate(format:"SELF MATCHES %@", zipcodeRegex)
        return zipcodeTest.evaluateWithObject(testStr)
    }
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func alertValidEmail() {
        var alert = UIAlertView(title: "Error", message: "Valid email required.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func alertValidPassword() {
        var alert = UIAlertView(title: "Error", message: "Enter a password.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func alertValidZipcode() {
        var alert = UIAlertView(title: "Error", message: "Enter a valid zipcode.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func login() {
        if self.email.isEmpty {
            alertValidEmail()
        }
        else if self.password.isEmpty {
            alertValidPassword()
        }
        else {
            request(.GET, "\(LNT_URL)/users/sign_in", parameters: nil).responseString { (request, response, json, error) -> Void in
                let csrfToken = response?.allHeaderFields["X-Csrf-Token"] as? String
                ServerManager.login(csrfToken!, email: self.email, password: self.password)
            }
        }
    }
    
    func postStats(csrfToken: String) {
        let authToken = "Yx9z4kQLKErd_RDiiuiE"
        let email = "derpy@test.com"
        let params = ["user_token":authToken, "user_email": email,
            "authenticity_token":csrfToken,
            "electricity_usage": 150,
            "month": "August",
            "year": 2015] as [String: AnyObject]
        
        request(.POST, "\(LNT_URL)/stats.json", parameters: params).responseString { (request, response, json, error) -> Void in
            println(request)
            println()
            println(response)
            println()
            println(json)
            println()
            println(error)
        }
    }
    
    func setHomeViewControllerToRoot() {
        let appDelegateTemp = UIApplication.sharedApplication().delegate
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        appDelegateTemp?.window??.rootViewController = storyboard.instantiateInitialViewController() as? UIViewController
    }
    
    func didPressButtonCell(buttonCell: ButtonCell) {
        switch buttonCell.title {
        case "Log In":
            login()
        case "Sign Up":
            signUp()
        default:
            break
        }
    }
    
    func didToggleCell(toggleCell: ToggleCell, on: Bool) {
        switch toggleCell.toggleLabel.text! {
        case "Electricity":
            usesElectricity = on
        case "Water":
            usesWater = on
        case "Natural Gas":
            usesNaturalGas = on
        default:
            break
        }
    }
    
    @IBAction func toggleAuthModeButtonPressed(sender: AnyObject) {
        activeMode == UserAuthViewMode.Login ? setRegistrationMode() : setLoginMode()
        tableView.reloadData()
    }
    
}