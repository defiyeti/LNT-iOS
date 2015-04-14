//
//  ButtonCell.swift
//  LNT
//
//  Created by Henry Popp on 3/28/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonCellDelegate {
    func didPressButtonCell(buttonCell: ButtonCell)
}

class ButtonCell: UITableViewCell {
    var delegate: ButtonCellDelegate?
    var title: String = ""
    @IBOutlet var button: UIButton!
    
    @IBAction func didPressButton(sender: AnyObject) {
        delegate?.didPressButtonCell(self)
    }
}