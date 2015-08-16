//
//  ForumListViewController.swift
//  Sample Project
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Bullitt
import UIKit

class ForumListViewController: UITableViewController {
    
    var forumService: ForumService!
    var forums = [Forum]()
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
        // Fill in your forum details here
        let apiURL = NSURL(string: "http://www.example.com/forum/api.php")!
        let apiKey = "YOUR_API_KEY"
        
        forumService = VBulletinForumService(apiURL: apiURL, apiKey: apiKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forumService.listForums({ (forums) -> () in
            self.forums = forums
            self.tableView.reloadData()
        }, failure: { (error) -> () in
            println(error)
        })
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
