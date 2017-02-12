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
    
    //dateFormatter
    let dateformatter = DateFormatter()

    //individual tweet cell
    var tweet: Tweet! {
        
        //use didSet to change the content of the cell
        didSet {
            
            //Changed the name
            nameButton.setTitle(tweet.user?.name as String?, for: .normal)
            //Changd the screenname and properly formatted it
            screennameButton.setTitle("@" + (tweet.user!.screenname as String!)!, for: .normal)
            //Changed the tweet text
            tweetLabel.text = tweet.text
            
            //Safely unwrap the profileURL and then set the image
            if let profileURL = tweet.user?.profileUrl{
                pictureImageView.setImageWith(profileURL as URL)
            }
            
            //Set the dateformat to hour:minute AM/PM format
            dateformatter.dateFormat = "h:mm a"
            //Set the date
            timestampButton.setTitle(dateformatter.string(from: tweet.timestamp!), for: .normal)

            //Figures out the appropriate image 
            //Depending upon if the current user favorited or retweeted a page
            let favoriteButtonImage = tweet.isFavorited ? "favor-icon-red" : "favor-icon"
            let retweetButtonImage = tweet.isRetweeted ? "retweet-icon-green" : "retweet-icon"
            //Set appropriate image where necessary
            likeButton.setImage(UIImage(named: favoriteButtonImage), for: UIControlState.normal)
            retweetButton.setImage(UIImage(named: retweetButtonImage), for: UIControlState.normal)
            
            //Set the favorite and retweet count
            likeButton.setTitle("\(tweet.favoritesCount)", for: .normal)
            retweetButton.setTitle("\(tweet.retweetCount)", for: .normal)

        }
    }
    
    //Action for when reply button is pressed
    @IBAction func replyButtonPressed(_ sender: Any) {
        print("TweetCell: replying")
        
    }
    
    //Action for when retweet button is pressed
    @IBAction func retweetButtonPressed(_ sender: Any) {
        
        print("TweetCell: retweeting")
        
        //If: the tweet has not been retweeted, then retweet
        //Else: the tweet has been retweeted, then unretweet
        if !(tweet.isRetweeted){
            
            //Using the sharedInstance to send the id of the tweet to retweet
            TwitterClient.sharedInstance?.createRetweet(id: tweet.idStr, success: {
                
                print("TweetCell: Retweet")
                
                //Changing the value of the isRetweeted to true
                self.tweet.isRetweeted = true
                
                //Image turns green when it is retweeted
                self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
                //Retweet count turns green
                self.retweetButton.setTitleColor(UIColor.green, for: UIControlState.normal)
                
                //Increase the retweet count by 1
                self.tweet.retweetCount += 1
                self.retweetButton.setTitle("\(self.tweet.retweetCount)", for: .normal)
                
            }, failure: { (error: Error) in
                print(error)
            })

        } else {
            
            //Using the sharedInstance to send the id of the tweet to unretweet
            TwitterClient.sharedInstance?.destroyRetweet(id: tweet.idStr, success: { 
                
                print("TweetCell: Unretweet")
                
                //Changes the status of isRetweeted to false
                self.tweet.isRetweeted = false
                
                //Image turns normal when it is unretweeted
                self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
                //Retweet count turns normal
                self.retweetButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                
                //Decrease the retweet count by 1
                self.tweet.retweetCount -= 1
                self.retweetButton.setTitle("\(self.tweet.retweetCount)", for: .normal)
                
            }, failure: { (error: Error) in
                print(error)
            })
            
        }
        
        
    }
    
    //Action for when favorite button is pressed
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        
        //Favoriting
        if !(tweet.isFavorited) {
            
            //Accessing the createFavorite method through the sharedInstance
            //Passing in the tweetID
            TwitterClient.sharedInstance?.createFavorite(params: ["id": self.tweet.idStr], success: { (retweet) in
                
                print("TweetCell: Favorited!")
                
                //Changes the status of isFavorited to true
                self.tweet.isFavorited = true
                
                //Image turns red when it is favorited
                self.likeButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
                //Favorite count turns red
                self.likeButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                
                //Increase the favorite count by 1
                self.tweet.favoritesCount += 1
                self.likeButton.setTitle("\(self.tweet.favoritesCount)", for: .normal)
                
                //Error
            }, failure: { (error: Error) in
                print("TweetCell: Error" + error.localizedDescription)
            })
            
            //Unfavoriting!
        } else {
            
            TwitterClient.sharedInstance?.destoryFavorite(params: ["id": self.tweet.idStr], success: { (retweet) in
                
                print("TweetCell: UnFavorited!")
                
                //Changes the status of isFavorited to false
                self.tweet.isFavorited = false
                
                //Image turns normal when it is unfavorited
                self.likeButton.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
                //Favorite count turns normal
                self.likeButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                
                //Decrease the favorite count by 1
                self.tweet.favoritesCount -= 1
                self.likeButton.setTitle("\(self.tweet.favoritesCount)", for: .normal)
                
                //Error
            }, failure: { (error: Error) in
                print("TweetCell: Error")
            })
            
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
