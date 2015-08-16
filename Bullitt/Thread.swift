//
//  Thread.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import SwiftyJSON

final class Thread: ResponseObjectSerializable {
    
    let identifier: String
    let title: String
    let lastPostDate: NSDate
    
    weak var forum: Forum?
    var posts: [Post] = []
    
    required init(response: NSHTTPURLResponse, json: JSON) {
        self.identifier = json["threadid"].stringValue
        
        let escapedTitle = json["threadtitle"].stringValue
        let unescapedTitle = escapedTitle.stringByReplacingOccurrencesOfString("&amp;", withString: "&", options: .LiteralSearch, range: nil)
        self.title = unescapedTitle
        
        let lastPostTimeInterval = NSString(string: json["lastposttime"].stringValue)
        self.lastPostDate = NSDate(timeIntervalSince1970: lastPostTimeInterval.doubleValue)
    }
}

// MARK: - ResponseCollectionSerializable

extension Thread: ResponseCollectionSerializable {
    
    class func collection(#response: NSHTTPURLResponse, json: JSON) -> [Thread] {
        var threads: [Thread] = []
        
        for threadJSON in json.arrayValue {
            let thread = Thread(response: response, json: threadJSON["thread"])
            threads.append(thread)
        }
        
        return threads
    }
}
