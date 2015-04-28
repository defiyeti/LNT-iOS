//
//  MultilineCell.swift
//  LNT
//
//  Created by Henry Popp on 4/24/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class MultilineCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var labelOne: UILabel?
    @IBOutlet var labelTwo: UILabel?
    @IBOutlet var labelThree: UILabel?
    
    func numLabels() -> Int {
        var count = 0
        count = textOne != nil ? count + 1 : count
        count = textTwo != nil ? count + 1 : count
        count = textThree != nil ? count + 1 : count
        
        return count
    }
    
    private var _title: String!
    var title: String! {
        get {
            return _title
        }
        
        set {
            titleLabel?.text = newValue
            _title = newValue
        }
    }
    
    private var _textOne: String?
    var textOne: String! {
        get {
            return _textOne
        }
        
        set {
            labelOne?.text = newValue
            _textOne = newValue
        }
    }
    
    private var _textTwo: String?
    var textTwo: String! {
        get {
            return _textTwo
        }
        
        set {
            labelTwo?.text = newValue
            _textTwo = newValue
        }
    }
    
    private var _textThree: String?
    var textThree: String! {
        get {
            return _textThree
        }
        
        set {
            labelThree?.text = newValue
            _textThree = newValue
        }
    }
}