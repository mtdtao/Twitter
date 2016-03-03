//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by ZengJintao on 2/16/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var tweet:Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.estimatedRowHeight = 350
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! TweetDetailTableViewCell
        print(tweet?.text)
        cell.contentLabel.text = tweet?.text
        cell.profileImageView.setImageWithURL(NSURL(string: (tweet?.user?.profileImageUrl)!)!)
        cell.retweetlikeCountLabel.text = "\((tweet?.retweetedCount)!) retweet  \((tweet?.favouritesCount)!) like"
        if let imageUrl = tweet?.mediaUrl {
            cell.mediaImageView.setImageWithURL(NSURL(string: imageUrl)!)
        }
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM/d/yy, HH/mm"
        cell.timeLabel.text = formatter.stringFromDate((tweet?.createdAt)!)
        
        let a = tweet!.favouritesCount
        let b = tweet!.retweetedCount
        cell.likeBtn.setTitle(a, forState: .Normal)
        cell.likeBtn.setTitle(a, forState: .Selected)
        cell.retweetBtn.setTitle(b, forState: .Normal)
        cell.retweetBtn.setTitle(b, forState: .Selected)
        
        if tweet!.retweeted == true {
            cell.retweetBtn.selected = true
        } else {
            cell.retweetBtn.selected = false
        }
        
        if tweet!.favorited == true {
            cell.retweetBtn.selected = true
        } else {
            cell.retweetBtn.selected = false
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    @IBAction func retweetPressed(sender: UIButton) {
        if tweet!.retweeted == false {
            
            tweet!.retweeted = true
            sender.selected = true
            TwitterClient.sharedInstance.retweetWithId(tweet!.id!,unretweet: false, params: ["id":"\(tweet!.id)"]) { (tweets, error) -> () in
                print("success retweet")
                
                sender.setTitle(tweets?.retweetedCount, forState: .Normal)
                sender.setTitle(tweets?.retweetedCount, forState: .Selected)
                
                print(tweets)
            }
        } else {
            tweet!.retweeted = false
            sender.selected = false
            TwitterClient.sharedInstance.retweetWithId(tweet!.id!,unretweet: true, params: ["id":"\(tweet!.id)"]) { (tweets, error) -> () in
                print("success unretweet")
                
                sender.setTitle(tweets?.retweetedCount, forState: .Normal)
                sender.setTitle(tweets?.retweetedCount, forState: .Selected)
                
                print(tweets?.retweeted)
            }
            print("aha")
        }
    }
    
    @IBAction func likePressed(sender: UIButton) {
        if tweet!.favorited == false {
            
            tweet!.favorited = true
            sender.selected = true
            TwitterClient.sharedInstance.favoriteWithId(["id":"\(tweet!.id!)"], unfavrorite: false) { (tweets, error) -> () in
                print("success retweet")
                
                sender.setTitle(tweets?.favouritesCount, forState: .Normal)
                sender.setTitle(tweets?.favouritesCount, forState: .Selected)
                
                print(tweets)
            }
        } else {
            tweet!.favorited = false
            sender.selected = false
            TwitterClient.sharedInstance.favoriteWithId(["id":"\(tweet!.id!)"], unfavrorite: true) { (tweets, error) -> () in
                print("success unretweet")
                
                sender.setTitle(tweets?.favouritesCount, forState: .Normal)
                sender.setTitle(tweets?.favouritesCount, forState: .Selected)
                
                
                print(tweets?.favorited)
            }
            print("aha")
        }

    }
    
    @IBAction func replyPressed(sender: UIButton) {
        let detailView = self.storyboard?.instantiateViewControllerWithIdentifier("PostTweetViewController") as! PostTweetViewController
        
        detailView.replyTweetId = tweet!.id
        self.navigationController?.pushViewController(detailView, animated: true)
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
