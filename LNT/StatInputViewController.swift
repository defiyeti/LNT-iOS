//
//  StatInputViewController.swift
//  LNT
//
//  Created by Henry Popp on 3/31/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class StatInputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
            cell.label.text = "Electricity"
            cell.gradientView.topColor = UIColor(red: 255/255.0, green: 205/255.0, blue: 62/255.0, alpha: 1.0)
            cell.gradientView.bottomColor = UIColor(red: 255/255.0, green: 205/255.0, blue: 0/255.0, alpha: 1.0)
            return cell
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
            cell.label.text = "Water"
            cell.gradientView.topColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
            cell.gradientView.bottomColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0)
            return cell
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
            cell.label.text = "Natural Gas"
            cell.gradientView.topColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            cell.gradientView.bottomColor = UIColor(red: 241/255.0, green: 0/255.0, blue: 204/255.0, alpha: 1.0)
            return cell
        case 3:
            var cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 3 ? 60 : 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}