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
    
    var tweetID: String?

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

            //Figures out the appropriate image 
            //Depending upon if the current user favorited or retweeted a page
            let favoriteButtonImage = tweet.isFavorited ? "favor-icon-red" : "favor-icon"
            let retweetButtonImage = tweet.isRetweeted ? "retweet-icon-green" : "retweet-icon"
            
            likeButton.setImage(UIImage(named: favoriteButtonImage), for: UIControlState.normal)
            retweetButton.setImage(UIImage(named: retweetButtonImage), for: UIControlState.normal)
            
            //Set the favorite count
            likeButton.setTitle("\(tweet.favoritesCount)", for: .normal)
            retweetButton.setTitle("\(tweet.retweetCount)", for: .normal)
            
            tweetID = tweet.idStr

        }
    }
    
    @IBAction func replyButtonPressed(_ sender: Any) {
        print("replying")
        
        
        
    }
    
    @IBAction func retweetButtonPressed(_ sender: Any) {
        print("retweeting")
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        print("favoriting")
        
        TwitterClient.sharedInstance?.createFavorite(params: ["id": tweetID], success: { (retweet) in
            print("Barabara is awesoem!")
        }, failure: { (error: Error) in
            print("Error" + error.localizedDescription)
        })
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
