//
//  TweetDetailViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/15/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

//Shows the tweets in more detail.
//Future: Also show replies
class TweetDetailViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var screennameButton: UIButton!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var directMessageButton: UIButton!
    @IBOutlet weak var retweetCountButton: UIButton!
    @IBOutlet weak var likeCount: UIButton!
    
    //dateformatter
    let dateformatter = DateFormatter()
    
    //tweet that will be displayed
    var tweet: Tweet!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets the main tweet
        setMainTweet()

    }
    
    
    //Adds all the content for the main tweet
    func setMainTweet() {
        
        //Changed the name
        nameButton.setTitle(tweet.user?.name as String?, for: .normal)
        //Changd the screenname and properly formatted it
        screennameButton.setTitle("@" + (tweet.user!.screenname as String!)!, for: .normal)
        //Changed the tweet text
        tweetLabel.text = tweet.text
        
        //Safely unwrap the profileURL and then set the image
        if let profileURL = tweet.user?.profileUrl{
            profileImageView.setImageWith(profileURL as URL)
        }
        
        //Set the dateformat to hour:minute AM/PM format
        dateformatter.dateFormat = "h:mm a"
        //Set the time
        timeLabel.text  = dateformatter.string(from: tweet.timestamp!)
        
        //Set the dateformat to day-month-year format
        dateformatter.dateFormat = "dd MMM YY"
        //Set the date
        dayLabel.text = dateformatter.string(from: tweet.timestamp!)

        //Figures out the appropriate image
        //Depending upon if the current user favorited or retweeted a page
        let favoriteButtonImage = tweet.isFavorited ? "favor-icon-red" : "favor-icon"
        let retweetButtonImage = tweet.isRetweeted ? "retweet-icon-green" : "retweet-icon"
        //Set appropriate image where necessary
        favoriteButton.setImage(UIImage(named: favoriteButtonImage), for: UIControlState.normal)
        retweetButton.setImage(UIImage(named: retweetButtonImage), for: UIControlState.normal)
        
        //sets the favoriteCount and retweetCount and displays them appropriately
        favoriteCountDisplay()
        retweetCountDisplay()
    
    }
    
    
    //formats the retweet count and adds the "s" for plurality
    func retweetCountDisplay () {
        
        //Temporary fix: if 0, then 0 tweetCount
        //Eventually, we want it to be hidden
        if (tweet.retweetCount == 0) {
            retweetCountButton.setTitle("\(tweet.retweetCount) RETWEETS", for: .normal)
            
        //if 1 retweet, then there is no plurarlity
        } else if (tweet.retweetCount == 1) {
            retweetCountButton.setTitle("\(tweet.retweetCount) RETWEET", for: .normal)
            
        //if more than 1 retweets, then add "s"
        } else {
            retweetCountButton.setTitle("\(tweet.retweetCount) RETWEETS", for: .normal)
        }
        
    }
    
    //Same concept as retweetCount
    func favoriteCountDisplay () {
        
        if (tweet.favoritesCount == 0) {
            likeCount.setTitle("\(tweet.favoritesCount) LIKES", for: .normal)
        } else if (tweet.favoritesCount == 1) {
            likeCount.setTitle("\(tweet.favoritesCount) LIKE", for: .normal)
        } else {
            likeCount.setTitle("\(tweet.favoritesCount) LIKES", for: .normal)
        }
        
    }

    
    //Action for the replyButton
    @IBAction func replyButtonPressed(_ sender: Any) {
        
        print("TweetDetailViewController/replyButtonPressed(): Reply Button Pressed.")
        
    }
    
    
    //Action for retweetButton
    @IBAction func retweetButtonPressed(_ sender: Any) {
        
        print("TweetDetailViewController/retweetButtonPressed(): Retweet Button Pressed.")
        
        //If: the tweet has not been retweeted, then retweet
        //Else: the tweet has been retweeted, then unretweet
        if !(tweet.isRetweeted){
            
            //Using the sharedInstance to send the id of the tweet to retweet
            TwitterClient.sharedInstance?.createRetweet(id: tweet.idStr, success: {
                
                print("TweetDetailViewController/retweetButtonPressed(): Retweet")
                
                //Changing the value of the isRetweeted to true
                self.tweet.isRetweeted = true
                
                //Image turns green when it is retweeted
                self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
                
                //Increase the retweet count by 1
                self.tweet.retweetCount += 1
                
                //Change the value on screen
                self.retweetCountDisplay()
                
                //Error
            }, failure: { (error: Error) in
                print("TweetDetailViewController/retweetButtonPressed() Error: \(error.localizedDescription)")
            })
            
        } else {
            
            //Using the sharedInstance to send the id of the tweet to unretweet
            TwitterClient.sharedInstance?.destroyRetweet(id: tweet.idStr, success: {
                
                print("TweetDetailViewController/retweetButtonPressed(): UnRetweet")
                
                //Changes the status of isRetweeted to false
                self.tweet.isRetweeted = false
                
                //Image turns normal when it is unretweeted
                self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
                
                //Decrease the retweet count by 1
                self.tweet.retweetCount -= 1
                
                //Change the value on screen
                self.retweetCountDisplay()
                
                //Error
            }, failure: { (error: Error) in
                print("TweetDetailViewController/retweetButtonPressed() Error: \(error.localizedDescription)")
            })
            
        }

    }
    
    
    //Action for favoriteButtonPressed
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        
        print("TweetDetailViewController/favoriteButtonPressed(): Favorite Button Pressed")
        
        //If: the tweet has not been favorited, then favorite
        //Else: the tweet has been favorited, then unfavorite
        if !(tweet.isFavorited) {
            
            //Accessing the createFavorite method through the sharedInstance
            //Passing in the tweetID
            TwitterClient.sharedInstance?.createFavorite(params: ["id": self.tweet.idStr], success: { (retweet) in
                
                print("TweetDetailViewController/favoriteButtonPressed(): Favorited!")
                
                //Changes the status of isFavorited to true
                self.tweet.isFavorited = true
                
                //Image turns red when it is favorited
                self.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
                
                //Increase the favorite count by 1
                self.tweet.favoritesCount += 1
                
                //Changes the value on screen
                self.favoriteCountDisplay()
                
                //Error
            }, failure: { (error: Error) in
                print("TweetDetailViewController/favoriteButtonPressed(): Error" + error.localizedDescription)
            })
            
        } else {
            
            //Accessing the destroyFavorite method through the shardInstance
            TwitterClient.sharedInstance?.destoryFavorite(params: ["id": self.tweet.idStr], success: { (retweet) in
                
                print("TweetDetailViewController/favoriteButtonPressed(): UnFavorited!")
                
                //Changes the status of isFavorited to false
                self.tweet.isFavorited = false
                
                //Image turns normal when it is unfavorited
                self.favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
                
                //Decrease the favorite count by 1
                self.tweet.favoritesCount -= 1
                
                //Changes the value on screen
                self.favoriteCountDisplay()
                
                //Error
            }, failure: { (error: Error) in
                print("TweetDetailViewController/favoriteButtonPressed(): Error" + error.localizedDescription)
            })
            
        }

    }
    
    
    //Action for directMessageButtonPressed
    @IBAction func directMessageButtonPressed(_ sender: Any) {
        
        print("TweetDetailViewController/directionMessageButtonPressed()")
        
    }
    

    //Bunch for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //reply to ComposeTweetViewController
        if segue.identifier == "replyFromDetailView" {
            
            //reference to composeTweetViewController
            let composeTweetViewController = segue.destination as! ComposeTweetViewController
            
            //setting the isReply to true
            composeTweetViewController.isReply = true
            
            //setting the tweet
            composeTweetViewController.tweet = tweet
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
