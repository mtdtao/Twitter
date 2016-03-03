//
//  MeViewController.swift
//  Twitter
//
//  Created by ZengJintao on 2/19/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var userTimeLineTableView: UITableView!
    
    var tweets: [Tweet]?
    var page = 1
    let newTweetOffset = 20
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTimeLineTableView.delegate = self
        userTimeLineTableView.dataSource = self
        userTimeLineTableView.rowHeight = UITableViewAutomaticDimension
        userTimeLineTableView.estimatedRowHeight = 350
        
        let frame = CGRectMake(0, userTimeLineTableView.contentSize.height, userTimeLineTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        userTimeLineTableView.addSubview(loadingMoreView!)
        
        var insets = userTimeLineTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        userTimeLineTableView.contentInset = insets
        
        print("user is \(user?.screenName)")
        
        if user == nil {
            user = User.currentUser
        }
        
        print("user screen name is \((user!.screenName)!)")
        
        TwitterClient.sharedInstance.showUserInfo(["screen_name":"\((user!.screenName)!)"]) { (user, error) -> () in
            self.user = user
            print("name is \(user!.screenName), \(user!.followingCount)")
            self.userTimeLineTableView.reloadData()
        }
        
        TwitterClient.sharedInstance.userTimelineWithParam(["screen_name":"\((user!.screenName)!)" , "count":"\(newTweetOffset)"]) { (tweets, error) -> () in
            self.tweets = tweets
            self.userTimeLineTableView.reloadData()
            // print(tweets)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = userTimeLineTableView.dequeueReusableCellWithIdentifier("userInfoCell") as! UserInfoTableViewCell
            print("this is \(self.user!.tweetsCount)")
            cell.tweetsCount.text = self.user!.tweetsCount
            cell.followingCount.text = self.user!.followingCount
            cell.followersCount.text = self.user!.followersCount
            cell.backgroundImageView.setImageWithURL(NSURL(string: (self.user!.backGroundImageUrl)!)!)
            cell.avatarImageView.setImageWithURL(NSURL(string: (self.user!.profileImageUrl)!)!)
            cell.userIdLabel.text = self.user!.name
            cell.usernameLabel.text = self.user!.screenName
            return cell
        }
        
        let cell = userTimeLineTableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetTableViewCell
        
        let tweet = tweets![indexPath.row - 1]
        
        let user = tweet.user
        //        print("tweet is \(user?.profileImageUrl)")
        cell.id = tweet.id
        
        
        
        let a = tweet.favouritesCount
        let b = tweet.retweetedCount
        cell.likeButton.setTitle(a, forState: .Normal)
        cell.likeButton.setTitle(a, forState: .Selected)
        cell.retweetButton.setTitle(b, forState: .Normal)
        cell.retweetButton.setTitle(b, forState: .Selected)
        
        if tweet.retweeted == true {
            cell.retweetButton.selected = true
        } else {
            cell.retweetButton.selected = false
        }
        
        if tweet.favorited == true {
            cell.likeButton.selected = true
        } else {
            cell.likeButton.selected = false
        }
        
        cell.profileImgeView.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
        cell.userNameLabel.text = user?.screenName
        cell.userIdLabel.text = "@\((user?.name)!)"
        cell.contentLabel.text = tweet.text
        let pastTime = NSDate().offsetFrom(tweet.createdAt!)
        cell.timeLabel.text = pastTime
        if let imgUrl = tweet.mediaUrl {
            print("there is img")
            print(imgUrl)
            cell.mediaImage.setImageWithURL(NSURL(string: imgUrl)!)
  
        } else {
            cell.imageHeightConstraint.constant = 0

            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 1
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            //print("hello")
            // ... Code to load more results ...
            let scrollViewContentHeight = userTimeLineTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - userTimeLineTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && userTimeLineTableView.dragging) {
                isMoreDataLoading = true
                let frame = CGRectMake(0, userTimeLineTableView.contentSize.height, userTimeLineTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                print("load more data")
                // ... Code to load more results ...
                
                TwitterClient.sharedInstance.userTimelineWithParam(["screen_name":"\(self.user!.screenName)"]) { (tweets, error) -> () in
                    self.tweets = tweets
                    self.userTimeLineTableView.reloadData()
                    // print(tweets)
                    self.loadingMoreView!.stopAnimating()
                    self.isMoreDataLoading = false
                }
                
            }
        }
    }
    
    @IBAction func retweetPressed(sender: UIButton) {
        
        
        let cell = sender.superview!.superview as! TweetTableViewCell
        let index = userTimeLineTableView.indexPathForCell(cell)!.row
        
        if tweets![index].retweeted == false {
            
            tweets![index].retweeted = true
            sender.selected = true
            TwitterClient.sharedInstance.retweetWithId(cell.id!,unretweet: false, params: ["id":"\(cell.id)"]) { (tweets, error) -> () in
                print("success retweet")
                
                cell.retweetButton.setTitle(tweets?.retweetedCount, forState: .Normal)
                cell.retweetButton.setTitle(tweets?.retweetedCount, forState: .Selected)
                
                print(tweets)
            }
            print("=========the id is \(cell.id)")
        } else {
            tweets![index].retweeted = false
            sender.selected = false
            TwitterClient.sharedInstance.retweetWithId(cell.id!,unretweet: true, params: ["id":"\(cell.id)"]) { (tweets, error) -> () in
                print("success unretweet")
                
                cell.retweetButton.setTitle(tweets?.retweetedCount, forState: .Normal)
                cell.retweetButton.setTitle(tweets?.retweetedCount, forState: .Selected)
                
                print(tweets?.retweeted)
            }
            print("aha")
        }
    }
    
    @IBAction func likePressed(sender: UIButton) {
        let cell = sender.superview!.superview as! TweetTableViewCell
        let index = userTimeLineTableView.indexPathForCell(cell)!.row
        
        if tweets![index].favorited == false {
            
            tweets![index].favorited = true
            sender.selected = true
            TwitterClient.sharedInstance.favoriteWithId(["id":"\(cell.id!)"], unfavrorite: false) { (tweets, error) -> () in
                print("success retweet")
                
                cell.likeButton.setTitle(tweets?.favouritesCount, forState: .Normal)
                cell.likeButton.setTitle(tweets?.favouritesCount, forState: .Selected)
                
                print(tweets)
            }
            print("=========the id is \(cell.id!)")
        } else {
            tweets![index].favorited = false
            sender.selected = false
            TwitterClient.sharedInstance.favoriteWithId(["id":"\(cell.id!)"], unfavrorite: true) { (tweets, error) -> () in
                print("success unretweet")
                
                cell.likeButton.setTitle(tweets?.favouritesCount, forState: .Normal)
                cell.likeButton.setTitle(tweets?.favouritesCount, forState: .Selected)
                
                
                print(tweets?.favorited)
            }
            print("aha")
        }
        
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
