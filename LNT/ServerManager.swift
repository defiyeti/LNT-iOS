//
//  ServerManager.swift
//  LNT
//
//  Created by Henry Popp on 4/7/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation

/// NSNotification sent when a user logs in
let UserDidLoginNotification = "UserDidLoginNotification"

/**
Manages all server connections
*/
class ServerManager {
    
    class func getStats(email: String!, userToken: String!, completion: (stats: [Statistic]) -> ()) {
        let params = ["user_token": userToken, "user_email": email]//, "authenticity_token":csrfToken]
         // [{"id":3,"email":"derpy@test.com","authentication_token":"Yx9z4kQLKErd_RDiiuiE","zip_code":75080,"carbon_footprint":150,"carbon_ranking":null,"electricity_ranking":0.25,"water_ranking":0.25,"natural_gas_ranking":0.25,"stats":[{"id":5,"electricity_usage":150,"water_usage":1020,"natural_gas_usage":40,"month":"August","year":2015,"user_id":3,"created_at":"2015-04-07T22:13:12.087Z","updated_at":"2015-04-08T01:09:24.672Z"}]}]
        LNT.request(.GET, "\(LNT_URL)/users/stats.json", parameters: params).responseJSON { (_, _, json, _) -> Void in
            if let jsonArray = json as? NSArray,
                let jsonDict = jsonArray.firstObject as? NSDictionary {
                let stats: [[String:AnyObject]] = jsonDict.objectForKey("stats") as! [[String:AnyObject]]
                var statistics: [Statistic] = []
                for stat: [String:AnyObject] in stats {
                    if let id: Int = stat["id"] as? Int,
                        let electricityUsage: Int = stat["electricity_usage"] as? Int,
                        let waterUsage: Int = stat["water_usage"] as? Int,
                        let naturalGasUsage: Int = stat["natural_gas_usage"] as? Int,
                        let month: String = stat["month"] as? String,
                        let year: Int = stat["year"] as? Int {
                            var s = Statistic(id: id, electricityUsage: electricityUsage, waterUsage: waterUsage, naturalGasUsage: naturalGasUsage, month: month, year: year, createdAt: NSDate(), updatedAt: NSDate())
                            statistics.append(s)
                    }
                }
                completion(stats: statistics)
            }
        }
    }
    
    /**
    Logs the user in

    :param: csrf            CSRF Token
    :param: email           E-mail address
    :param: password        User's password

    :returns: No return value
    */
    class func login(csrf: String, email: String!, password: String!) {
        let params = ["user":["email": email, "password": password], "authenticity_token":csrf] as [String:AnyObject]
        request(.POST, "\(LNT_URL)/users/sign_in", parameters: params).responseString { (request, response, json, error) -> Void in
            let authToken = response?.allHeaderFields["X-Auth-Token"] as? String
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
        }
    }
}
