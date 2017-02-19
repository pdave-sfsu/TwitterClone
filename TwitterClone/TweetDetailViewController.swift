//
//  TweetDetailViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/15/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

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
    
    let dateformatter = DateFormatter()
    
    //tweet that will be displayed
    var tweet: Tweet!

    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMainTweet()

        // Do any additional setup after loading the view.
    }
    
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
        //Set the date
        timeLabel.text  = dateformatter.string(from: tweet.timestamp!)
        
        //Set the dateformat to hour:minute AM/PM format
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
        

        favoriteCountDisplay()

        retweetCountDisplay()
        
    
        //Checks to see if tweet is favorited
        //if favorited, then change the title to red
        //else: Change the title to darkGray
        if tweet.isFavorited {
            favoriteButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        } else {
            favoriteButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        }
        
        //Checks to see if the tweet is retweeted
        //If favorited, then change the title to green
        //else: Change the title to darkGray
        if tweet.isRetweeted {
            retweetButton.setTitleColor(UIColor.green, for: UIControlState.normal)
        } else {
            retweetButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        }
    
    }
    
    func retweetCountDisplay () {
        
        //Set the favorite and retweet count
        if (tweet.retweetCount == 0) {
            retweetCountButton.setTitle("\(tweet.retweetCount) RETWEETS", for: .normal)
        } else if (tweet.retweetCount == 1) {
            retweetCountButton.setTitle("\(tweet.retweetCount) RETWEET", for: .normal)
        } else {
            retweetCountButton.setTitle("\(tweet.retweetCount) RETWEETS", for: .normal)
        }
        
    }
    
    func favoriteCountDisplay () {
        
        //Set the favorite and retweet count
        if (tweet.favoritesCount == 0) {
            likeCount.setTitle("\(tweet.favoritesCount) LIKES", for: .normal)
        } else if (tweet.favoritesCount == 1) {
            likeCount.setTitle("\(tweet.favoritesCount) LIKE", for: .normal)
        } else {
            likeCount.setTitle("\(tweet.favoritesCount) LIKES", for: .normal)
        }
        
    }

    
    @IBAction func replyButtonPressed(_ sender: Any) {
        print("Reply button pressed")
        
        
    }
    
    @IBAction func retweetButtonPressed(_ sender: Any) {
        print("retweet button pressed")
        
        //If: the tweet has not been retweeted, then retweet
        //Else: the tweet has been retweeted, then unretweet
        if !(tweet.isRetweeted){
            
            //Using the sharedInstance to send the id of the tweet to retweet
            TwitterClient.sharedInstance?.createRetweet(id: tweet.idStr, success: {
                
                print("TweetDetailView: Retweet")
                
                //Changing the value of the isRetweeted to true
                self.tweet.isRetweeted = true
                
                //Image turns green when it is retweeted
                self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
                //Retweet count turns green
                self.retweetButton.setTitleColor(UIColor.green, for: UIControlState.normal)
                
                //Increase the retweet count by 1
                self.tweet.retweetCount += 1
                //Change the value on screen
                
                
                self.retweetCountDisplay()
                
                //Error
            }, failure: { (error: Error) in
                print("TweetCell: Error: \(error)")
            })
            
        } else {
            
            //Using the sharedInstance to send the id of the tweet to unretweet
            TwitterClient.sharedInstance?.destroyRetweet(id: tweet.idStr, success: {
                
                print("TweetCell: UnRetweet")
                
                //Changes the status of isRetweeted to false
                self.tweet.isRetweeted = false
                
                //Image turns normal when it is unretweeted
                self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
                //Retweet count turns normal
                self.retweetButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                
                //Decrease the retweet count by 1
                self.tweet.retweetCount -= 1
                //Change the value on screen
                
                self.retweetCountDisplay()
                
                //Error
            }, failure: { (error: Error) in
                print("TweetCell: Error: \(error)")
            })
            
        }

    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        print("favorite button pressed")
        
        //If: the tweet has not been favorited, then favorite
        //Else: the tweet has been favorited, then unfavorite
        if !(tweet.isFavorited) {
            
            //Accessing the createFavorite method through the sharedInstance
            //Passing in the tweetID
            TwitterClient.sharedInstance?.createFavorite(params: ["id": self.tweet.idStr], success: { (retweet) in
                
                print("tweetdetailView: Favorited!")
                
                //Changes the status of isFavorited to true
                self.tweet.isFavorited = true
                
                //Image turns red when it is favorited
                self.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
                //Favorite count turns red
                self.favoriteButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                
                //Increase the favorite count by 1
                self.tweet.favoritesCount += 1
                //Changes the value on screen
                
                self.favoriteCountDisplay()
                
                //Error
            }, failure: { (error: Error) in
                print("TweetCell: Error" + error.localizedDescription)
            })
            
        } else {
            
            //Accessing the destroyFavorite method through the shardInstance
            TwitterClient.sharedInstance?.destoryFavorite(params: ["id": self.tweet.idStr], success: { (retweet) in
                
                print("TweetCell: UnFavorited!")
                
                //Changes the status of isFavorited to false
                self.tweet.isFavorited = false
                
                //Image turns normal when it is unfavorited
                self.favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
                //Favorite count turns normal
                self.favoriteButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                
                //Decrease the favorite count by 1
                self.tweet.favoritesCount -= 1
                //Changes the value on screen
                
                self.favoriteCountDisplay()
                
                //Error
            }, failure: { (error: Error) in
                print("TweetCell: Error" + error.localizedDescription)
            })
            
        }

    }
    
    @IBAction func directMessageButtonPressed(_ sender: Any) {
        print("DM button pressed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "replyFromDetailView" {
            
            let composeTweetViewController = segue.destination as! ComposeTweetViewController
            
            composeTweetViewController.replyUser = tweet.user
            
            composeTweetViewController.isReply = true
            
            composeTweetViewController.tweet = tweet
        }
        
    }
 

}
