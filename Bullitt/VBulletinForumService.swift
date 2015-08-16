//
//  VBulletinForumService.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Alamofire
import SwiftyJSON

private struct APIInfo {
    let token: String
    let clientId: String
    let apiVersion: Int
    let secret: String
}

private enum ErrorCode: Int {
    case InvalidResponse = 100
}

class VBulletinForumService {
    
    private let manager: Alamofire.Manager
    private let apiURL: NSURL
    private let apiKey: String
    
    private class var errorDomain: String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        
        return infoDictionary["CFBundleIdentifier"] as! String
    }
    
    private class var defaultUserAgent: String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let bundleName = infoDictionary["CFBundleName"] as! String
        let shortVersionString = infoDictionary["CFBundleShortVersionString"] as! String
        
        return bundleName + "/" + shortVersionString
    }
    
    private var apiInfo: APIInfo!
    
    init(apiURL: NSURL, apiKey: String) {
        self.apiURL = apiURL
        self.apiKey = apiKey
        
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["User-Agent"] = VBulletinForumService.defaultUserAgent
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        self.manager = Alamofire.Manager(configuration: configuration)
    }
}

// MARK: - ForumService

extension VBulletinForumService: ForumService {
    
    func listForums(success: (forums: [Forum]) -> (), failure: (error: NSError) -> ()) {
        generateAPIParameters("api_forumlist", parameters: nil, success: { (apiParameters) -> () in
            manager.request(.GET, self.apiURL, parameters: apiParameters)
                   .responseCollection { (_, _, forums: [Forum]?, error: NSError?) in
                    if error != nil {
                        success(forums: forums ?? [])
                    } else {
                        failure(error: error!)
                    }
            }
        }, failure: { (error) -> () in
            failure(error: error)
        })
    }
    
    func loadThreads(forum: Forum, perPage: Int, pageNumber: Int, success: (threads: [Thread]) -> (), failure: (error: NSError) -> ()) {
        let parameters: [String: AnyObject] = [
            "forumid": forum.identifier,
            "perpage": perPage,
            "pagenumber": pageNumber
        ]
        
        generateAPIParameters("forumdisplay", parameters: nil, success: { (apiParameters) -> () in
            manager.request(.GET, self.apiURL, parameters: apiParameters)
                   .responseCollection { (_, _, threads: [Thread]?, error: NSError?) in
                    if error != nil {
                        success(threads: threads ?? [])
                    } else {
                        failure(error: error!)
                    }
            }
        }, failure: { (error) -> () in
                failure(error: error)
        })
    }
    
    func loadPosts(thread: Thread, pageNumber: Int, success: (posts: [Post]) -> (), failure: (error: NSError) -> ()) {
        let parameters : [String: AnyObject] = [
            "threadid": thread.identifier,
            "pagenumber": pageNumber
        ]
        
        generateAPIParameters("showthread", parameters: nil, success: { (apiParameters) -> () in
            manager.request(.GET, self.apiURL, parameters: apiParameters)
                   .responseCollection { (_, _, posts: [Post]?, error: NSError?) in
                    if error != nil {
                        success(posts: posts ?? [])
                    } else {
                        failure(error: error!)
                    }
                }
            }, failure: { (error) -> () in
                failure(error: error)
        })
    }
}

// MARK: - Internal

extension VBulletinForumService {
    
    private func apiSignature(parameters: [String: AnyObject]) -> String {
        var unhashedSignature = ""
        let sortedKeys = sorted(parameters.keys)
        
        for key in sortedKeys {
            if count(unhashedSignature) > 0 {
                unhashedSignature += "&"
            }
            
            var value: AnyObject = parameters[key]!
            unhashedSignature += "\(key)=\(value)"
        }
        
        unhashedSignature += apiInfo.token
        unhashedSignature += apiInfo.clientId
        unhashedSignature += apiInfo.secret
        unhashedSignature += apiKey
        
        return unhashedSignature.MD5()
    }
    
    private func apiInit(success: () -> (), failure: (error: NSError) -> ()) {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let currentDevice = UIDevice.currentDevice()
        let parameters = [
            "api_m": "api_init",
            "clientname": infoDictionary["CFBundleDisplayName"] as! NSString,
            "clientversion": infoDictionary["CFBundleShortVersionString"] as! NSString,
            "platformname": currentDevice.model,
            "platformversion": currentDevice.systemVersion,
            "uniqueid": currentDevice.identifierForVendor.UUIDString
        ]
        
        manager.request(.GET, apiURL, parameters: parameters)
               .responseJSON { _, _, json, error in
                if let error = error {
                    failure(error: error)
                } else {
                    if let responseDictionary = json as? [String: AnyObject] {
                        println(responseDictionary)
                        var token = responseDictionary["apiaccesstoken"] as? NSString
                        var clientId = responseDictionary["apiclientid"] as? NSString
                        var apiVersion = responseDictionary["apiversion"] as AnyObject? as? Int
                        var secret = responseDictionary["secret"] as? NSString
                        
                        if token != nil && clientId != nil && apiVersion != nil && secret != nil {
                            self.apiInfo = APIInfo(token: token! as String, clientId: clientId! as String, apiVersion: apiVersion!, secret: secret! as String)
                            success()
                        } else {
                            let error = NSError(domain: VBulletinForumService.errorDomain, code: ErrorCode.InvalidResponse.rawValue, userInfo: nil)
                            failure(error: error)
                        }
                    }
                }
        }
    }
    
    private func generateAPIParameters(method: String, parameters: [String: AnyObject]?, success: (apiParameters: [String: AnyObject]) -> (), failure: (error: NSError) -> ()) {
        
        func apiParametersBuilder() {
            var apiParameters = [String: AnyObject]()
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    apiParameters[key] = value
                }
            }
            
            apiParameters["api_m"] = method
            apiParameters["api_sig"] = apiSignature(apiParameters)
            apiParameters["api_c"] = apiInfo.clientId
            apiParameters["api_s"] = apiInfo.token
            apiParameters["api_v"] = apiInfo.apiVersion
            
            success(apiParameters: apiParameters)
        }
        
        if apiInfo != nil {
            apiParametersBuilder()
        } else {
            apiInit(apiParametersBuilder, failure: failure)
        }
    }
}
