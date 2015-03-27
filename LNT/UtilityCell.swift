//
//  UtilityCell.swift
//  LNT
//
//  Created by Henry Popp on 3/27/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class UtilityCell: UITableViewCell {
    var utilityName: String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yourConsumptionLabel: UILabel!
    @IBOutlet weak var localAverageLabel: UILabel!
}
