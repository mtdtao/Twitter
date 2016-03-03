//
//  TweetDetailTableViewCell.swift
//  Twitter
//
//  Created by ZengJintao on 2/16/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class TweetDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCntLable: UILabel!
    
    @IBOutlet weak var retweetlikeCountLabel: UILabel!
    
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
