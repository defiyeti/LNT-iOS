//
//  MonthYearPickerCell.swift
//  LNT
//
//  Created by Henry Popp on 4/14/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class MonthYearPickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var picker: UIPickerView!
    
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear, fromDate: date)
        let year = components.year
        var years: [Int] = []
        for var i = 4; i >= 0; i-- {
            years.append(year - i)
        }
        
        if component == 0 {
            return months[row]
        }
        else if component == 1 {
            return String(years[row])
        }
        return ""
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
}