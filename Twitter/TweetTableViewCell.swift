//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by ZengJintao on 2/10/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImgeView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
        
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    
    var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        retweetButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        replyButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        likeButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit

        
        mediaImage.layer.cornerRadius = 5
        mediaImage.layer.masksToBounds = true
        

        profileImgeView.layer.cornerRadius = 3
        profileImgeView.layer.masksToBounds = true
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
//    @IBAction func retweetPressed(sender: AnyObject) {
//        TwitterClient.sharedInstance.retweetWithId(id!, params: nil) { (tweets, error) -> () in
//            print("success in cell")
//        }
//    }
    

}
