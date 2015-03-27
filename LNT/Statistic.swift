//
//  Statistic.swift
//  LNT
//
//  Created by Henry Popp on 3/27/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation

class Statistic {
    let id: Int!
    let electricityUsage: Int?
    let waterUsage: Int?
    let naturalGasUsage: Int?
    let month: String!
    let year: Int!
    let createdAt: NSDate!
    let updatedAt: NSDate!
    
    init(id: Int!, electricityUsage: Int?, waterUsage: Int?, naturalGasUsage: Int?,
        month: String!, year: Int!, createdAt: NSDate!, updatedAt: NSDate!) {
            self.id = id
            self.electricityUsage = electricityUsage
            self.waterUsage = waterUsage
            self.naturalGasUsage = naturalGasUsage
            self.month = month
            self.year = year
            self.createdAt = createdAt
            self.updatedAt = updatedAt
    }
}