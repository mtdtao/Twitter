//
//  TweetsViewController.swift
//  Twitter
//
//  Created by ZengJintao on 2/9/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

let twitterColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)



class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var tweets: [Tweet]?
    var page = 1
    let newTweetOffset = 20
    
    @IBOutlet weak var homelineTabelView: UITableView!
    var refreshControl: UIRefreshControl!
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        homelineTabelView.delegate = self
        homelineTabelView.dataSource = self
        homelineTabelView.rowHeight = UITableViewAutomaticDimension
        homelineTabelView.estimatedRowHeight = 350
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Twitter_logo_blue_32"))
        self.navigationController?.navigationBar.translucent = false
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        homelineTabelView.insertSubview(refreshControl, atIndex: 0)

        let frame = CGRectMake(0, homelineTabelView.contentSize.height, homelineTabelView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        homelineTabelView.addSubview(loadingMoreView!)
        
        var insets = homelineTabelView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        homelineTabelView.contentInset = insets
        
        TwitterClient.sharedInstance.homeTimelineWithParam(["count":"\(newTweetOffset)"]) { (tweets, error) -> () in
            self.tweets = tweets
            self.homelineTabelView.reloadData()
           // print(tweets)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = homelineTabelView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetTableViewCell
        
        var user = tweets![indexPath.row].user
//        print("tweet is \(user?.profileImageUrl)")
        cell.id = tweets![indexPath.row].id

        
        
        let a = tweets![indexPath.row].favouritesCount
        let b = tweets![indexPath.row].retweetedCount
        cell.likeButton.setTitle(a, forState: .Normal)
        cell.likeButton.setTitle(a, forState: .Selected)
        cell.retweetButton.setTitle(b, forState: .Normal)
        cell.retweetButton.setTitle(b, forState: .Selected)
        
        if tweets![indexPath.row].retweeted == true {
            cell.retweetButton.selected = true
        } else {
            cell.retweetButton.selected = false
        }
        
        if tweets![indexPath.row].favorited == true {
            cell.likeButton.selected = true
        } else {
            cell.likeButton.selected = false
        }
        
        cell.profileImgeView.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
        cell.userNameLabel.text = user?.screenName
        cell.userIdLabel.text = "@\((user?.name)!)"
        cell.contentLabel.text = tweets![indexPath.row].text
        var pastTime = NSDate().offsetFrom(tweets![indexPath.row].createdAt!)
        cell.timeLabel.text = pastTime
        if let imgUrl = tweets![indexPath.row].mediaUrl {
            print("there is img")
            print(imgUrl)
            cell.mediaImage.setImageWithURL(NSURL(string: imgUrl)!)

//                
//            }
        } else {
//            cell.mediaImage.hidden = true
//            let imageHeight = cell.mediaImage.frame.height
//            let cellOriginalFrame = cell.frame
//            cell.frame = CGRectMake(cellOriginalFrame.origin.x, cellOriginalFrame.origin.y, cellOriginalFrame.width, cellOriginalFrame.height - imageHeight)
//            if cell.aspectRatioConstraint != nil && cell.imageHeightConstraint != nil {
//                cell.aspectRatioConstraint.active = false
//                cell.imageHeightConstraint.active = true
                cell.imageHeightConstraint.constant = 0
//
//            }

        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
        
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
        TwitterClient.sharedInstance.homeTimelineWithParam(["count":"5"]) { (tweets, error) -> () in
            self.tweets = tweets
            self.homelineTabelView.reloadData()
            self.refreshControl.endRefreshing()
            }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            print("hello")
            // ... Code to load more results ...
            let scrollViewContentHeight = homelineTabelView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - homelineTabelView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && homelineTabelView.dragging) {
                isMoreDataLoading = true
                let frame = CGRectMake(0, homelineTabelView.contentSize.height, homelineTabelView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                print("load more data")
                // ... Code to load more results ...
                
                TwitterClient.sharedInstance.homeTimelineWithParam(["count":"\(newTweetOffset * ++page)"]) { (tweets, error) -> () in
                    self.tweets = tweets
                    self.homelineTabelView.reloadData()
                    // print(tweets)
                    self.loadingMoreView!.stopAnimating()
                    self.isMoreDataLoading = false
                }
                
            }
        }
    }
    
    @IBAction func retweetPressed(sender: UIButton) {
        
        
        let cell = sender.superview!.superview as! TweetTableViewCell
        let index = homelineTabelView.indexPathForCell(cell)!.row
        
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
        let index = homelineTabelView.indexPathForCell(cell)!.row
        
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

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
