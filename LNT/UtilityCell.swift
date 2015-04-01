//
//  UtilityCell.swift
//  LNT
//
//  Created by Henry Popp on 3/27/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UtilityCell: UITableViewCell {
    
    private var _utilityName: String!
    var utilityName: String! {
        get {
            return _utilityName
        }
        
        set {
            titleLabel.text = newValue
            _utilityName = newValue
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yourConsumptionLabel: UILabel!
    @IBOutlet weak var localAverageLabel: UILabel!
    @IBOutlet weak var protoGraphView: UIView!
    @IBOutlet var background: GradientView!
}
