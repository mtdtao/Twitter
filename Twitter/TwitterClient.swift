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
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func favoriteWithId(params: NSDictionary?, unfavrorite: Bool, completion: (tweets: Tweet?, error: NSError?) -> ()) {
        var unfavoriteUrlAdd = "create"
        if unfavrorite == true {
            unfavoriteUrlAdd = "destroy"
        }
        
        POST("1.1/favorites/\(unfavoriteUrlAdd).json", parameters: params, success: { (operation:NSURLSessionDataTask, response:AnyObject?) -> Void in
            print("successful favorite in client!================")
            var tweeta = Tweet(dictionary: response as! NSDictionary)
            completion(tweets: tweeta, error: nil)
            
            }) { (operation:NSURLSessionDataTask?, error:NSError) -> Void in
                print("fail to favorite in client=======")
        }
        
        
    }
    
    
    func retweetWithId(id: String, unretweet: Bool, params: NSDictionary?, completion: (tweets: Tweet?, error: NSError?) -> ()) {
        var unretweetUrlAdd = ""
        if unretweet == true {
            unretweetUrlAdd = "un"
        }
        
        POST("1.1/statuses/\(unretweetUrlAdd)retweet/\(id).json", parameters: params, success: { (operation:NSURLSessionDataTask, response:AnyObject?) -> Void in
            print("successful retweet in client!================")
            var tweeta = Tweet(dictionary: response as! NSDictionary)
            completion(tweets: tweeta, error: nil)
            
            }) { (operation:NSURLSessionDataTask?, error:NSError) -> Void in
                print("fail to retweet in client=======")
        }
        
        
    }
    
    func homeTimelineWithParam(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation:NSURLSessionDataTask, response:AnyObject?) -> Void in
//            print(response)
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            for tweet in tweets {
//                print("text: \(tweet.text), created at: \(tweet.createdAt)")
                
            }
            completion(tweets: tweets, error: nil)
            
        }, failure: { (operation:NSURLSessionDataTask?, error:NSError) -> Void in
            print("error getting home time line")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("/oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("get request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("fail to get token")
        }
        
    }
    
    func openUrl(url: NSURL?) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url!.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Get Access token")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("/1.1/account/verify_credentials.json", parameters: nil, success: { (operation:NSURLSessionDataTask, response:AnyObject?) -> Void in
                //                print("user:\(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user = \(user.name)")
                self.loginCompletion?(user: user, error: nil)

                }, failure: { (operation:NSURLSessionDataTask?, error:NSError) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            
            }) { (error: NSError!) -> Void in
                print("fail to get access token")
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
}
