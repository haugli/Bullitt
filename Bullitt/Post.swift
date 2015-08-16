//
//  Post.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import SwiftyJSON

final class Post: ResponseObjectSerializable {
    
    let identifier: String
    let messageBBCode: String
    let username: String
    let date: NSDate
    
    weak var thread: Thread?
    
    required init(response: NSHTTPURLResponse, json: JSON) {
        self.identifier = json["postid"].stringValue
        self.messageBBCode = json["message_bbcode"].stringValue
        self.username = json["username"].stringValue
        
        let postTimeInterval = NSString(string: json["posttime"].stringValue)
        self.date = NSDate(timeIntervalSince1970: postTimeInterval.doubleValue)
    }
}

// MARK: - ResponseCollectionSerializable

extension Post: ResponseCollectionSerializable {
    
    class func collection(#response: NSHTTPURLResponse, json: JSON) -> [Post] {
        var posts: [Post] = []
        
        for postJSON in json.arrayValue {
            let post = Post(response: response, json: postJSON["post"])
            posts.append(post)
        }
        
        return posts
    }
}
