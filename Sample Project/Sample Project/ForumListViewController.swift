//
//  ForumListViewController.swift
//  Sample Project
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Bullitt
import UIKit

class ForumListViewController: UITableViewController {
    
    var forums = [Forum]()
    
    var forumService: ForumService! {
        didSet {
            forumService.listForums({ (forums) -> () in
                self.forums = forums
                self.tableView.reloadData()
                }, failure: { (error) -> () in
                    println(error)
            })
        }
    }
}

// MARK:- UITableViewDataSource

extension ForumListViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forums.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ForumCell", forIndexPath: indexPath) as! UITableViewCell
        
        let forum = forums[indexPath.row]
        cell.textLabel!.text = forum.title
        
        return cell
    }
}

// MARK:- UITableViewDelegate

extension ForumListViewController: UITableViewDelegate {
    
}
