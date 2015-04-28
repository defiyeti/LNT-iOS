//
//  User.swift
//  LNT
//
//  Created by Henry Popp on 4/24/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation

class User {
    var id: Int?
    var email: String?
    var zipcode: String?
    var usesElectricity = false
    var usesWater = false
    var usesNaturalGas = false
    var stats: [Statistic] = []
    
    init(email: String?, zipcode: String?) {
        self.email = email
        self.zipcode = zipcode
    }
}
