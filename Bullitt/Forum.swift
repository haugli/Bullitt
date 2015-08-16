//
//  Forum.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import SwiftyJSON

final class Forum: ResponseObjectSerializable {
    
    let identifier: String
    let title: String
    let isCategory: Bool
    
    weak var superforum: Forum?
    var subforums: [Forum] = []
    var threads: [Thread] = []
    
    required init(response: NSHTTPURLResponse, json: JSON) {
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
    
    class func collection(#response: NSHTTPURLResponse, json: JSON) -> [Forum] {
        var forums: [Forum] = []
        
        for forumJSON in json.arrayValue {
            let forum = Forum(response: response, json: forumJSON)
            forums.append(forum)
        }
        
        return forums
    }
}
