//
//  UserInfoTableViewCell.swift
//  Twitter
//
//  Created by ZengJintao on 2/19/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
