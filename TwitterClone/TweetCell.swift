//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/6/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    //Outlet for the view
    @IBOutlet weak var tweetCell: UIView!
    
    //Outlets
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var screennameButton: UIButton!
    @IBOutlet weak var timestampButton: UIButton!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    let dateformatter = DateFormatter()

    //individual tweet cell
    var tweet: Tweet! {
        
        didSet {
            
            //Changed the name
            nameButton.setTitle(tweet.user?.name as String?, for: .normal)
            
            //Changd the screenname
            screennameButton.setTitle("@" + (tweet.user!.screenname as String!)!, for: .normal)
            
            //Changed the tweet text
            tweetLabel.text = tweet.text
            
            //Safely unwrap the profileURL and then set the image
            if let profileURL = tweet.user?.profileUrl{
                pictureImageView.setImageWith(profileURL as URL)
            }
            
            //Set the dateformat
            dateformatter.dateFormat = "MMM d, h:mm a"
            
            //Set the date
            timestampButton.setTitle(dateformatter.string(from: tweet.timestamp!), for: .normal)

            //Set the favorite count
            likeButton.setTitle("\(tweet.favoritesCount)", for: .normal)

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
