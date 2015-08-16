//
//  VBulletinAPIInfo.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import SwiftyJSON

struct VBulletinAPIInfo: ResponseObjectSerializable {
    
    let token: String
    let clientId: String
    let apiVersion: Int
    let secret: String

    init?(response: NSHTTPURLResponse, json: JSON) {
        let token = json["apiaccesstoken"].string
        let clientId = json["apiclientid"].string
        let apiVersion = json["apiversion"].int
        let secret = json["secret"].string
        
        if token != nil && clientId != nil && apiVersion != nil && secret != nil {
            self.token = token!
            self.clientId = clientId!
            self.apiVersion = apiVersion!
            self.secret = secret!
        } else {
            var missingFields: [String] = []
            if token == nil {
                missingFields.append("token")
            }
            if clientId == nil {
                missingFields.append("clientId")
            }
            if apiVersion == nil {
                missingFields.append("apiVersion")
            }
            if secret == nil {
                missingFields.append("secret")
            }
            
            println("API initialization failed, missing " + ", ".join(missingFields))
            
            return nil
        }
    }
}
