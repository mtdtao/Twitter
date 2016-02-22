
//
//  User.swift
//  Twitter
//
//  Created by ZengJintao on 2/9/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var id: String?
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var followersCount: String?
    var followingCount: String?
    var tweetsCount: String?
    var backGroundImageUrl: String?
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        followersCount = "\(dictionary["followers_count"]!)"
        followingCount = "\(dictionary["friends_count"]!)"
        tweetsCount = "\(dictionary["statuses_count"]!)"
        backGroundImageUrl = dictionary["profile_background_image_url"] as? String
        
        print("use init \(followersCount), \(followingCount), \(tweetsCount)")
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                var data = try! NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
}
