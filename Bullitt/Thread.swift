//
//  Thread.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import SwiftyJSON

public final class Thread: ResponseObjectSerializable {
    
    public let identifier: String
    public let title: String
    public let lastPostDate: NSDate
    
    public weak var forum: Forum?
    public var posts: [Post] = []
    
    required public init?(response: NSHTTPURLResponse, json: JSON) {
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
    
    public class func collection(#response: NSHTTPURLResponse, json: JSON) -> [Thread] {
        var threads: [Thread] = []
        let threadBits = json["response"]["threadbits"]
        
        for threadJSON in threadBits.arrayValue {
            if let thread = Thread(response: response, json: threadJSON["thread"]) {
                threads.append(thread)
            }
        }
        
        return threads
    }
}
