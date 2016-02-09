//
//  TwitterClient.swift
//  Twitter
//
//  Created by ZengJintao on 2/8/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "U2OB8XHD2uJcHFB0euePziovL"
let twitterConsumerSecret = "gDHjOjKrlFGBfuJIUUoDAUHBrNwyszie8zli32izhdy4d5SP02"
let twitterBaseURL = NSURL(string: "https://apps.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
}
