//
//  PostViewController.swift
//  Sample Project
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Bullitt
import UIKit

class PostViewController: UITableViewController {
    
    var posts: [Post] = []
    
    var thread: Thread? {
        didSet {
            if let thread = thread {
                title = thread.title
                loadPostsIfNeeded()
            }
        }
    }
    
    var forumService: ForumService? {
        didSet {
            loadPostsIfNeeded()
        }
    }
}

// MARK:- UITableViewDataSource

extension PostViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! UITableViewCell
        
        let post = posts[indexPath.row]
        let message = post.messageBBCode
        let bbCodeTagExpression = NSRegularExpression(pattern: "\\[.*?\\]", options: .allZeros, error: nil)
        let strippedMessage = bbCodeTagExpression?.stringByReplacingMatchesInString(message, options: .allZeros, range: NSMakeRange(0, count(message)), withTemplate: "")
        
        cell.textLabel!.text = strippedMessage
        
        return cell
    }
}

// MARK:- Internal

extension PostViewController {
    
    func loadPostsIfNeeded() {
        if let forumService = forumService, thread = thread {
            forumService.loadPosts(thread, pageNumber: 1, success: { (posts) -> () in
                self.posts = posts
                self.tableView.reloadData()
            }, failure: { (error) -> () in
                println(error)
            })
        }
    }
}
