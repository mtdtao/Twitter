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
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
