//
//  AppDelegate.swift
//  Sample Project
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Bullitt
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        // Fill in your forum details here
        let apiURL = "http://www.example.com/forum/api.php"
        let apiKey = "YOUR_API_KEY"
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            if let forumListViewController = navigationController.topViewController as? ForumListViewController {
                let forumService = VBulletinForumService(apiURL: NSURL(string: apiURL)!, apiKey: apiKey)
                forumListViewController.forumService = forumService
            }
        }
        
        return true
    }
}
