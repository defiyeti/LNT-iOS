//
//  MonthYearPickerCell.swift
//  LNT
//
//  Created by Henry Popp on 4/14/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

protocol MonthYearPickerCellDelegate {
    func didChangeDate(pickerCell: MonthYearPickerCell, month: Int, year: Int)
}

class MonthYearPickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var picker: UIPickerView!
     var delegate: MonthYearPickerCellDelegate?
    
    let MONTH_COMPONENT = 0
    let YEAR_COMPONENT = 1
    
    var month: Int = 0
    var year: Int = 2015
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    private var _years: [String] = []
    var years: [String] {
        get {
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Year, fromDate: date)
            let year = components.year
            var y: [String] = []
            for var i = 4; i >= 0; i-- {
                y.append("\(year - i)")
            }
            return y
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 12
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func select(month: Int, year: Int) {
        picker.selectRow(month, inComponent: 0, animated: false)
        var y = years.indexOf("\(year)")
        y = y != nil ? y : 0
        picker.selectRow(y!, inComponent: 1, animated: false)
        self.month = month
        self.year = year
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == MONTH_COMPONENT {
            month = row
        }
        else if component == YEAR_COMPONENT {
            year = Int(years[row])!
        }
        delegate?.didChangeDate(self, month: month, year: year)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        if component == MONTH_COMPONENT {
            return months[row]
        }
        else if component == YEAR_COMPONENT {
            return String(years[row])
        }
        return ""
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
}