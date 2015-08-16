//
//  Post.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import SwiftyJSON

public final class Post: ResponseObjectSerializable {
    
    public let identifier: String
    public let messageBBCode: String
    public let username: String
    public let date: NSDate
    
    public weak var thread: Thread?
    
    required public init?(response: NSHTTPURLResponse, json: JSON) {
        self.identifier = json["postid"].stringValue
        self.messageBBCode = json["message_bbcode"].stringValue
        self.username = json["username"].stringValue
        
        let postTimeInterval = NSString(string: json["posttime"].stringValue)
        self.date = NSDate(timeIntervalSince1970: postTimeInterval.doubleValue)
    }
}

// MARK: - ResponseCollectionSerializable

extension Post: ResponseCollectionSerializable {
    
    public class func collection(#response: NSHTTPURLResponse, json: JSON) -> [Post] {
        var posts: [Post] = []
        
        for postJSON in json.arrayValue {
            if let post = Post(response: response, json: postJSON["post"]) {
                posts.append(post)
            }
        }
        
        return posts
    }
}
