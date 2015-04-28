//
//  ToggleCell.swift
//  LNT
//
//  Created by Henry Popp on 3/29/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

protocol ToggleCellDelegate {
    func didToggleCell(toggleCell: ToggleCell, on: Bool)
}

class ToggleCell: UITableViewCell {
    var delegate: ToggleCellDelegate?
    @IBOutlet var toggleLabel: UILabel!
    @IBOutlet var toggleSwitch: UISwitch!
    @IBOutlet var background: GradientView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        toggleSwitch.addTarget(self, action: "changeSwitch:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func changeSwitch(sender: UISwitch) {
        delegate?.didToggleCell(self, on: sender.on)
    }
    
    func toggle(on: Bool, animated: Bool) {
        toggleSwitch.setOn(on, animated: animated)
        delegate?.didToggleCell(self, on: on)
    }
    
    func on() -> Bool {
        return toggleSwitch.on
    }
}
