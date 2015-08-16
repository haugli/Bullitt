//
//  VBulletinForumService.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Alamofire

public class VBulletinForumService {
    
    private let manager: Alamofire.Manager
    private let apiURL: NSURL
    private let apiKey: String
    private var apiInfo: VBulletinAPIInfo!
        
    private class var userAgent: String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let bundleName = infoDictionary["CFBundleName"] as? String ?? "Bullitt"
        let shortVersionString = infoDictionary["CFBundleShortVersionString"] as? String ?? "1.0"
        
        return bundleName + "/" + shortVersionString
    }
    
    public init(apiURL: NSURL, apiKey: String) {
        self.apiURL = apiURL
        self.apiKey = apiKey
        
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["User-Agent"] = VBulletinForumService.userAgent
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        self.manager = Alamofire.Manager(configuration: configuration)
    }
}

// MARK: - ForumService

extension VBulletinForumService: ForumService {
    
    public func listForums(success: (forums: [Forum]) -> (), failure: (error: NSError) -> ()) {
        generateAPIParameters("api_forumlist", parameters: nil, success: { (apiParameters) -> () in
            manager.request(.GET, self.apiURL, parameters: apiParameters)
                   .responseCollection { (_, _, forums: [Forum]?, error: NSError?) in
                    if let error = error {
                        failure(error: error)
                    } else {
                        success(forums: forums ?? [])
                    }
            }
        }, failure: { (error) -> () in
            failure(error: error)
        })
    }
    
    public func loadThreads(forum: Forum, perPage: Int, pageNumber: Int, success: (threads: [Thread]) -> (), failure: (error: NSError) -> ()) {
        let parameters: [String: AnyObject] = [
            "forumid": forum.identifier,
            "perpage": perPage,
            "pagenumber": pageNumber
        ]
        
        generateAPIParameters("forumdisplay", parameters: parameters, success: { (apiParameters) -> () in
            manager.request(.GET, self.apiURL, parameters: apiParameters)
                   .responseCollection { (_, _, threads: [Thread]?, error: NSError?) in
                    if let error = error {
                        failure(error: error)
                    } else {
                        success(threads: threads ?? [])
                    }
            }
        }, failure: { (error) -> () in
            failure(error: error)
        })
    }
    
    public func loadPosts(thread: Thread, pageNumber: Int, success: (posts: [Post]) -> (), failure: (error: NSError) -> ()) {
        let parameters : [String: AnyObject] = [
            "threadid": thread.identifier,
            "pagenumber": pageNumber
        ]
        
        generateAPIParameters("showthread", parameters: parameters, success: { (apiParameters) -> () in
            manager.request(.GET, self.apiURL, parameters: apiParameters)
                   .responseCollection { (_, _, posts: [Post]?, error: NSError?) in
                    if let error = error {
                        failure(error: error)
                    } else {
                        success(posts: posts ?? [])
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
            "clientname": infoDictionary["CFBundleName"] as! NSString,
            "clientversion": infoDictionary["CFBundleShortVersionString"] as! NSString,
            "platformname": currentDevice.model,
            "platformversion": currentDevice.systemVersion,
            "uniqueid": currentDevice.identifierForVendor.UUIDString
        ]
        
        manager.request(.GET, apiURL, parameters: parameters)
               .responseObject { (_, _, apiInfo: VBulletinAPIInfo?, error: NSError?) in
                if let apiInfo = apiInfo {
                    self.apiInfo = apiInfo
                    success()
                } else {
                    let actualError: NSError
                    if let error = error {
                        actualError = error
                    } else {
                        actualError = NSError(domain: VBulletinError.domain, code: VBulletinError.APIInitializationFailure.rawValue, userInfo: nil)
                    }
                    
                    failure(error: actualError)
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
