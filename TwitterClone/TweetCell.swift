//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/6/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetCell: UIView!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var screennameButton: UIButton!
    @IBOutlet weak var timestampButton: UIButton!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    var tweet: Tweet! {
        
        didSet {
            
            nameButton.setTitle(tweet.user?.name as String?, for: .normal)
            
            screennameButton.setTitle("@\(tweet.user?.screenname as String?)", for: .normal)
            
            tweetLabel.text = tweet.text
            
            if let profileURL = tweet.user?.profileUrl{
                pictureImageView.setImageWith(profileURL as URL)
            }
            
//            timestampButton.setTitle(tweet.timestamp as! String, for: .normal)

//            likeButton.setTitle("\(tweet.favoritesCount)", for: .normal)

            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
