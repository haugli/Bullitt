//
//  Forum.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import SwiftyJSON

public final class Forum: ResponseObjectSerializable {
    
    public let identifier: String
    public let title: String
    public let isCategory: Bool
    
    public weak var superforum: Forum?
    public var subforums: [Forum] = []
    public var threads: [Thread] = []
    
    required public init?(response: NSHTTPURLResponse, json: JSON) {
        self.identifier = json["forumid"].stringValue
        self.isCategory = json["is_category"].boolValue
        
        let escapedTitle = json["title"].stringValue
        let unescapedTitle = escapedTitle.stringByReplacingOccurrencesOfString("&amp;", withString: "&", options: .LiteralSearch, range: nil)
        self.title = unescapedTitle
        
        self.subforums = Forum.collection(response: response, json: json["subforums"])
        for subforum in subforums {
            subforum.superforum = self
        }
    }
}

// MARK: - ResponseCollectionSerializable

extension Forum: ResponseCollectionSerializable {
    
    public class func collection(#response: NSHTTPURLResponse, json: JSON) -> [Forum] {
        var forums: [Forum] = []
        
        for forumJSON in json.arrayValue {
            if let forum = Forum(response: response, json: forumJSON) {
                forums.append(forum)
            }
        }
        
        return forums
    }
}
