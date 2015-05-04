//
//  ServerManager.swift
//  LNT
//
//  Created by Henry Popp on 4/7/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

/// NSNotification sent when a user logs in
let UserDidLoginNotification = "UserDidLoginNotification"

/**
Manages all server connections
*/
class ServerManager {
    
    class func getStats(email: String!, userToken: String!, completion: (stats: [Statistic], electricityRanking: [String:AnyObject], waterRanking: [String:AnyObject], naturalGasRankings: [String:AnyObject], carbonFootprintRanking: [String:AnyObject], usesElectricity: Bool, usesWater: Bool, usesNaturalGas: Bool) -> ()) {
        let params = ["user_token": userToken, "user_email": email]
        LNT.request(.GET, "\(LNT_URL)/users/stats.json", parameters: params).responseJSON { (_, _, json, _) -> Void in
            println(json)
            if let jsonDict = json as? NSDictionary {
                let stats: [[String:AnyObject]] = jsonDict.objectForKey("last_twelve_months") as! [[String:AnyObject]]
                var statistics: [Statistic] = []
                for stat: [String:AnyObject] in stats {
                    if let s = ServerManager.parseStat(stat) {
                            statistics.append(s)
                    }
                }
                let electricity = (jsonDict.objectForKey("electricity_ranking") as? NSDictionary) as? [String:AnyObject]
                let water = (jsonDict.objectForKey("water_ranking") as? NSDictionary) as? [String:AnyObject]
                let naturalGas = (jsonDict.objectForKey("natural_gas_ranking") as? NSDictionary) as? [String:AnyObject]
                let carbonFootprint = (jsonDict.objectForKey("carbon_ranking") as? NSDictionary) as? [String:AnyObject]
                
                let usesElectricity = jsonDict.objectForKey("uses_electricity") as! Bool
                let usesWater = jsonDict.objectForKey("uses_water") as! Bool
                let usesNaturalGas = jsonDict.objectForKey("uses_natural_gas") as! Bool
                    
                completion(stats: statistics, electricityRanking: electricity!, waterRanking: water!, naturalGasRankings: naturalGas!, carbonFootprintRanking: carbonFootprint!, usesElectricity: usesElectricity, usesWater: usesWater, usesNaturalGas: usesNaturalGas)
            }
        }
    }
    
    class func updateUser(id: Int, email: String, password: String, zipCode: String, usesElectricity: Bool, usesWater: Bool, usesNaturalGas: Bool, completion: (error: NSError?) -> ()) {
        LNT.request(.GET, "\(LNT_URL)/users/sign_in", parameters: nil).responseString { (request, response, json, error) -> Void in
            
            if let csrfToken = response?.allHeaderFields["X-Csrf-Token"] as? String {
                ServerManager.updateUser(csrfToken, id: id, email: email, password: password, zipCode: zipCode, usesElectricity: usesElectricity, usesWater: usesWater, usesNaturalGas: usesNaturalGas, completion: completion)
            }
            else {
                let error = NSError(domain: NSURLErrorDomain, code: -1005, userInfo: nil)
                completion(error: error)
            }
        }
    }
    
    private class func updateUser(csrfToken: String, id: Int, email: String, password: String, zipCode: String, usesElectricity: Bool, usesWater: Bool, usesNaturalGas: Bool, completion: (error: NSError?) -> ()) {
        let oldEmail = NSUserDefaults.standardUserDefaults().objectForKey(USER_EMAIL_DEFAULTS_KEY) as! String
        let (dictionary, error) = Locksmith.loadDataForUserAccount(oldEmail)
        let authToken = dictionary?.objectForKey(USER_TOKEN_KEY) as! String
        
        var userParams = [String: AnyObject]()
        if !email.isEmpty {
            userParams["email"] = email
        }
        if !password.isEmpty {
            userParams["password"] = password
        }
        if !zipCode.isEmpty {
            userParams["zip_code"] = zipCode.toInt()
        }
        userParams["uses_electricity"] = usesElectricity
        userParams["uses_water"] = usesWater
        userParams["uses_natural_gas"] = usesNaturalGas
        var params = ["user_token":authToken,
            "user_email": oldEmail,
            "authenticity_token":csrfToken,
            "user": userParams] as [String: AnyObject]
        
        LNT.request(.PUT, "\(LNT_URL)/users/\(id).json", parameters: params).responseString { (request, response, json, error) -> Void in
            completion(error: error)
        }
    }
  
    /**
    Returns more detailed user information and all stats associated with that account.
    
    :param: completion  Completion block with a user object
    */
    class func getUserDetails(completion: (user: User) -> ()) {
        let email = NSUserDefaults.standardUserDefaults().objectForKey(USER_EMAIL_DEFAULTS_KEY) as! String
        let (dictionary, error) = Locksmith.loadDataForUserAccount(email)
        let authToken = dictionary?.objectForKey(USER_TOKEN_KEY) as! String
        
        getUserDetails(email, userToken: authToken, completion: completion)
    }
    
    private class func parseStat(stat: [String: AnyObject]) -> Statistic? {
        if let id: Int = stat["id"] as? Int,
            let month: Int = stat["month"] as? Int,
            let year: Int = stat["year"] as? Int {
                let electricityUsage: Int? = stat["electricity_usage"] as? Int
                let waterUsage: Int? = stat["water_usage"] as? Int
                let naturalGasUsage: Int? = stat["natural_gas_usage"] as? Int
                let carbonFootprint: Int? = stat["carbon_footprint"] as? Int
                return Statistic(id: id, electricityUsage: electricityUsage, waterUsage: waterUsage, naturalGasUsage: naturalGasUsage, carbonFootprint: carbonFootprint, month: month, year: year, createdAt: NSDate(), updatedAt: NSDate())
        }
        return nil
    }
    
    private class func getUserDetails(email: String!, userToken: String!, completion: (user: User) -> ()) {
        let params = ["user_token": userToken, "user_email": email]
        LNT.request(.GET, "\(LNT_URL)/users/show.json", parameters: params).responseJSON { (_, _, json, _) -> Void in
            if let jsonDict = json as? NSDictionary {
                var user = User(email: email, zipcode: jsonDict.objectForKey("zip_code") as? String)
                user.id = jsonDict.objectForKey("id") as? Int
                user.usesElectricity = jsonDict.objectForKey("uses_electricity") as! Bool
                user.usesWater = jsonDict.objectForKey("uses_water") as! Bool
                user.usesNaturalGas = jsonDict.objectForKey("uses_natural_gas") as! Bool
                var zip = jsonDict.objectForKey("zip_code") as? Int
                user.zipcode = "\(zip)"
                let stats: [[String:AnyObject]] = jsonDict.objectForKey("stats") as! [[String:AnyObject]]
                var statistics: [Statistic] = []
                for stat: [String:AnyObject] in stats {
                    if let s = ServerManager.parseStat(stat) {
                            statistics.append(s)
                    }
                }
                user.stats = statistics.reverse()
                completion(user: user)
            }
        }
    }
    
    class func alertNoInternetConnection() {
        var alert = UIAlertView(title: "Error", message: "Cannot connect to the server. Please check your network settings and try again.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    class func alertLoginFailed() {
        var alert = UIAlertView(title: "Error", message: "Username/password credentials invalid.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    /**
    Logs the user in
    
    :param: email           E-mail address
    :param: password        User's password
    :param: completion      Block to be executed after completion of login
    
    :returns: No return value
    */
    class func login(email: String!, password: String!, completion: (error: NSError?) -> ()) {
        request(.GET, "\(LNT_URL)/users/sign_in", parameters: nil).responseString { (request, response, json, error) -> Void in
            let csrfToken = response?.allHeaderFields["X-Csrf-Token"] as? String
            if csrfToken == nil || error != nil {
                completion(error: error)
                if error?.code == -1004 {
                    ServerManager.alertNoInternetConnection()
                }
            }
            else {
                ServerManager.login(csrfToken!, email: email, password: password, completion: completion)
            }
        }
    }

    private class func login(csrf: String, email: String!, password: String!, completion: (error: NSError?) -> ()) {
        let params = ["user":["email": email, "password": password], "authenticity_token":csrf] as [String:AnyObject]
        println(params)
        request(.POST, "\(LNT_URL)/users/sign_in", parameters: params).responseString { (request, response, json, error) -> Void in
            let authToken = response?.allHeaderFields["X-Auth-Token"] as? String
            completion(error: error)
            println(response)
            println(response?.statusCode)
            if response?.statusCode == 401 {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    ServerManager.alertLoginFailed()
                })
            }
            if authToken != nil {
                let error = Locksmith.saveData([USER_TOKEN_KEY: authToken!], forUserAccount: email)
                NSUserDefaults.standardUserDefaults().setValue(email, forKey: USER_EMAIL_DEFAULTS_KEY)
                NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginNotification, object: nil)
            }
        }
    }
    
    /**
    Signs the user in
    
    :param: csrf                CSRF Token
    :param: email               E-mail address
    :param: password            User's password
    :param: zipcode             User's zipcode
    :param: usesElectricity     Does the user want to see electricity stats?
    :param: usesWater           Does the user want to see water stats?
    :param: usesNaturalGas      Does the user want to see natural gas stats?
    */
    class func signUp(csrfToken: String, email: String, password: String, zipcode: String, usesElectricity: Bool, usesWater: Bool, usesNaturalGas: Bool) {
        let params = ["user":["email": email, "password": password,
            "zip_code": zipcode, "uses_electricity": usesElectricity, "uses_water": usesWater, "uses_natural_gas": usesNaturalGas],
            "authenticity_token": csrfToken] as [String:AnyObject]
        
        LNT.request(.POST, "\(LNT_URL)/users", parameters: params).responseString { (request, response, json, error) -> Void in
            let authToken = response?.allHeaderFields["X-Auth-Token"] as? String
            if authToken != nil {
                let error = Locksmith.saveData([USER_TOKEN_KEY: authToken!], forUserAccount: email)
                NSUserDefaults.standardUserDefaults().setValue(email, forKey: USER_EMAIL_DEFAULTS_KEY)
                NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginNotification, object: nil)
            }
            println(response)
        }
    }
    
    class func postStats(stat: Statistic, completion: (error: NSError?) -> ()) {
        LNT.request(.GET, "\(LNT_URL)/users/sign_in", parameters: nil).responseString { (request, response, json, error) -> Void in
            
            if let csrfToken = response?.allHeaderFields["X-Csrf-Token"] as? String {
                ServerManager.postStats(csrfToken, stat: stat, completion: completion)
            }
            else {
                let error = NSError(domain: NSURLErrorDomain, code: -1005, userInfo: nil)
                completion(error: error)
            }
        }
    }
    
    private class func postStats(csrfToken: String!, stat: Statistic, completion: (error: NSError?) -> ()) {
        let email = NSUserDefaults.standardUserDefaults().objectForKey(USER_EMAIL_DEFAULTS_KEY) as! String
        let (dictionary, error) = Locksmith.loadDataForUserAccount(email)
        let authToken = dictionary?.objectForKey(USER_TOKEN_KEY) as! String
        
        var params = ["user_token":authToken,
            "user_email": email,
            "authenticity_token":csrfToken,
            "month": stat.month,
            "year": stat.year] as [String: AnyObject]
        
        if let electricityUsage = stat.electricityUsage {
            params["electricity_usage"] = electricityUsage
        }
        if let waterUsage = stat.waterUsage {
            params["water_usage"] = waterUsage
        }
        if let naturalGasUsage = stat.naturalGasUsage {
            params["natural_gas_usage"] = naturalGasUsage
        }
        
        LNT.request(.POST, "\(LNT_URL)/stats.json", parameters: params).responseString { (request, response, json, error) -> Void in
            completion(error: error)
        }
    }
    
    class func getTips(utility: Utility, completion: (tips: [UtilityTip]) -> ()) {
        var utilityString = ""
        switch utility {
        case Utility.Electricity:
            utilityString = "electricity"
        case Utility.Water:
            utilityString = "water"
        case Utility.NaturalGas:
            utilityString = "natural_gas"
        default:
            break
        }
        LNT.request(.GET, "\(LNT_URL)/utility_tips/\(utilityString).json", parameters: nil).responseJSON { (_, _, json, _) -> Void in
            var tips: [UtilityTip] = []
            if let jsonArray = json as? [[String:AnyObject]] {
                for jsonTip in jsonArray {
                    if let id: Int = jsonTip["id"] as? Int,
                        let order: Int = jsonTip["order"] as? Int,
                        let text: String = jsonTip["text"] as? String {
                            var tip = UtilityTip(id: id, order: order, text: text)
                            tips.append(tip)
                    }
                }
            }
            completion(tips: tips)
        }
    }
}
