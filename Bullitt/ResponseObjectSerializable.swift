//
//  ResponseObjectSerializable.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Alamofire
import SwiftyJSON

public protocol ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, json: JSON)
}

extension Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
        let responseSerializer = GenericResponseSerializer<T> { request, response, data in
            var error: NSError?
            
            if let response = response, data = data {
                let json = JSON(data: data, options: .AllowFragments, error: &error)
                
                if error == nil {
                    return (T(response: response, json: json), nil)
                }
            }
            
            return (nil, error)
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
