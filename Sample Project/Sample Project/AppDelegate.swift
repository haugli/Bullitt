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

    /**********************************************************
     * Fill in your vBulletin mobile API configuration below: *
     **********************************************************/
    let apiURL = "http://www.example.com/forum/api.php"
    let apiKey = "YOUR_API_KEY"
    /**********************************************************/
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        if let navigationController = window?.rootViewController as? UINavigationController {
            if let forumListViewController = navigationController.topViewController as? ForumViewController {
                let forumService = VBulletinForumService(apiURL: NSURL(string: apiURL)!, apiKey: apiKey)
                forumListViewController.forumService = forumService
            }
        }
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        if apiKey == "YOUR_API_KEY" {
            let alertController = UIAlertController(title: "Setup Required", message: "Please fill in your vBulletin API configuration in AppDelegate.swift.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
