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
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    func startLoading() {
        button.setTitle("", forState: UIControlState.Normal)
        loadingIndicator.startAnimating()
        loadingIndicator.hidden = false
    }
    
    func stopLoading() {
        button.setTitle(title, forState: UIControlState.Normal)
        loadingIndicator.hidden = true
        loadingIndicator.stopAnimating()
    }
    
    @IBAction func didPressButton(sender: AnyObject) {
        delegate?.didPressButtonCell(self)
    }
}