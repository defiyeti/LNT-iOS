//
//  TipsViewController.swift
//  LNT
//
//  Created by Henry Popp on 3/31/15.
//  Copyright (c) 2015 Henry Popp. All rights reserved.
//

import Foundation
import UIKit

class UtilityTip {
    var id: Int
    var order: Int
    var text: String
    
    init(id: Int, order: Int, text: String) {
        self.id = id
        self.order = order
        self.text = text
    }
}

class TipsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var activeUtility: Utility?
    var tips: [UtilityTip] = []
    
    override func viewWillAppear(animated: Bool) {
        ServerManager.getTips(activeUtility!, completion: { (tips) -> () in
            self.tips = tips
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TipCell") as! UITableViewCell
        cell.textLabel?.text = tips[indexPath.row].text
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
}