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
        var cell = tableView.dequeueReusableCellWithIdentifier("TipCell") as! TextViewCell
        cell.textView?.text = tips[indexPath.row].text
        let width = cell.textView?.frame.size.width
//        cell.textView?.frame.size = CGSize(width: width!, height: heightForTextView(tips[indexPath.row].text))
        cell.textView?.frame = (tips[indexPath.row].text as NSString).boundingRectWithSize(CGSize(width: width!, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17)], context: nil)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    /*
    - (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
    {
    float horizontalPadding = 24;
    float verticalPadding = 16;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    float height = [string sizeWithFont:[UIFont systemFontOfSize:kFontSize] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height;
    }
    */
    
    func heightForTextView(string: String) -> CGFloat {
        return (string as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17)]).height
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let width = self.tableView.frame.size.width - 20
        return (tips[indexPath.row].text as NSString).boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17)], context: nil).size.height + 20
    }
}