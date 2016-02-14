//
//  ViewController.swift
//  Twitter
//
//  Created by ZengJintao on 2/8/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        TwitterClient(
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> () in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                
            }
        }
    }

}

