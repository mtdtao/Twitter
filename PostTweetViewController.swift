//
//  PostTweetViewController.swift
//  Twitter
//
//  Created by ZengJintao on 2/21/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

var newTweetCallback:Tweet?

class PostTweetViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var newTweetContent: UITextField!
    @IBOutlet weak var charactarLimits: UILabel!
    @IBOutlet weak var sendStatusView: UIView!
    @IBOutlet weak var sendStatusToBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.setImageWithURL(NSURL(string: (User.currentUser?.profileImageUrl)!)!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(sender: UIButton) {
        if newTweetContent.text == nil {
            var alert = UIAlertController(title: "Please enter", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if newTweetContent.text?.characters.count > 140 {
            var alert = UIAlertController(title: "Please enter less than 140 charactars", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            TwitterClient.sharedInstance.postNewTweet(["status":"\(newTweetContent.text!)"], completion: { (tweets, error) -> () in
                newTweetCallback = tweets
                self.performSegueWithIdentifier("unwindToHomeLineVC", sender: self)
                //                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func keyboardWasShown(notification:NSNotification) {
        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            self.sendStatusToBottomConstraint.constant = rect.height
            
            
            }, completion: {
                (finished:Bool) in
        })
    }
    
    func keyboardWillHide(notification:NSNotification) {
        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            self.sendStatusToBottomConstraint.constant = 0

            
            }, completion: {
                (finished:Bool) in
        })
    }
    
    @IBAction func newTweetContentChanging(sender: AnyObject) {
        var charLeft = 140 - (newTweetContent.text?.characters.count)!
        
        charactarLimits.text = "\(charLeft)"
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
