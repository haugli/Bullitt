//
//  ThreadViewController.swift
//  Sample Project
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Bullitt
import UIKit

class ThreadViewController: UITableViewController {
    
    var threads: [Thread] = []
    
    var forum: Forum? {
        didSet {
            if let forum = forum {
                title = forum.title
                loadThreadsIfNeeded()
            }
        }
    }
    
    var forumService: ForumService? {
        didSet {
            loadThreadsIfNeeded()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow(), segueIdentifier = segue.identifier {
            let selectedThread = threads[selectedIndexPath.row]
            
            switch segueIdentifier {
                case "showPost":
                    if let postViewController = segue.destinationViewController as? PostViewController {
                        postViewController.thread = selectedThread
                        postViewController.forumService = forumService
                    }
                default:
                    break
            }
        }
    }
}

// MARK:- UITableViewDataSource

extension ThreadViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ThreadCell", forIndexPath: indexPath) as! UITableViewCell
        
        let thread = threads[indexPath.row]
        cell.textLabel!.text = thread.title
        
        return cell
    }
}

// MARK:- UITableViewDelegate

extension ThreadViewController: UITableViewDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let thread = threads[indexPath.row]
        performSegueWithIdentifier("showPost", sender: self)
    }
}

// MARK:- Internal

extension ThreadViewController {
    
    func loadThreadsIfNeeded() {
        if let forumService = forumService, forum = forum {
            forumService.loadThreads(forum, perPage: 20, pageNumber: 1, success: { (threads) -> () in
                self.threads = threads
                self.tableView.reloadData()
            }, failure: { (error) -> () in
                println(error)
            })
        }
    }
}
