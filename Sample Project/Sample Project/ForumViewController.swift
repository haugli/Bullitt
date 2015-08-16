//
//  ForumViewController.swift
//  Sample Project
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Bullitt
import UIKit

class ForumViewController: UITableViewController {
    
    var forums: [Forum] = []
    
    var categoryForum: Forum? {
        didSet {
            if let categoryForum = categoryForum {
                title = categoryForum.title
                forums = categoryForum.subforums
                tableView.reloadData()
            }
        }
    }
    
    var forumService: ForumService? {
        didSet {
            listThreadsIfNeeded()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow(), segueIdentifier = segue.identifier {
            let selectedForum = forums[selectedIndexPath.row]
            
            switch segueIdentifier {
                case "showForum":
                    if let forumViewController = segue.destinationViewController as? ForumViewController {
                        forumViewController.categoryForum = selectedForum
                        forumViewController.forumService = forumService
                    }
                case "showThread":
                    if let threadViewController = segue.destinationViewController as? ThreadViewController {
                        threadViewController.forum = selectedForum
                        threadViewController.forumService = forumService
                    }
                default:
                    break
            }
        }
    }
}

// MARK:- UITableViewDataSource

extension ForumViewController: UITableViewDataSource {
    
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

extension ForumViewController: UITableViewDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let forum = forums[indexPath.row]
        let segueIdentifier = forum.isCategory ? "showForum" : "showThread"
        performSegueWithIdentifier(segueIdentifier, sender: self)
    }
}

// MARK:- Internal

extension ForumViewController {

    func listThreadsIfNeeded() {
        if categoryForum == nil {
            if let forumService = forumService {
                forumService.listForums({ (forums) -> () in
                    self.forums = forums
                    self.tableView.reloadData()
                    }, failure: { (error) -> () in
                        println(error)
                })
            }
        }
    }
}
