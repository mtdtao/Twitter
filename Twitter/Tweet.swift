//
//  Tweet.swift
//  Twitter
//
//  Created by ZengJintao on 2/9/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var mediaUrl: String?
    var id: String?
    var retweeted: Bool?
    var retweetedCount: String?
    var favorited:Bool?
    var favouritesCount: String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        
        let idNumber = dictionary["id"] as? NSNumber
        id = "\(idNumber!)"
        
        let retweetCount = dictionary["retweet_count"] as? NSNumber
//        print("retweetCount is \(retweetCount)")
        retweetedCount = "\(retweetCount!)"
        
        let favoCount = dictionary["favorite_count"]
//        print("favoCount is \(favoCount)")
        favouritesCount = "\(favoCount!)"
        
        let entities = dictionary["entities"] as! NSDictionary

        if let media = entities["media"] {
            let mediaArray = media as! NSArray
            mediaUrl = mediaArray[0]["media_url"] as! String
        }
        
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]  {
        var tweets = [Tweet]()
        
        for arr in array {
            tweets.append(Tweet(dictionary: arr))
        }
        
        return tweets
    }
}
