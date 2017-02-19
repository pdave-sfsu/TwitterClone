//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/17/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var tweetCountButton: UIButton!
    
    @IBOutlet weak var composeTweet: UIButton!
    
    var user: User!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user.screenname != User._currentUser?.screenname {
            composeTweet.isHidden = true
        } else {
            composeTweet.isHidden = false
        }
        
        if (user != nil) {
            setProfileByUser()
        }
        
        
        
        if (tweet != nil) {
            setProfileByTweet()
        }
        

        // Do any additional setup after loading the view.
    }
    
    func setProfileByUser() {
        print("Profile being set by user")
        
        if let profileURL = user.profileUrl {
            profileImageView.setImageWith(profileURL as URL)
        }
        
        nameLabel.text = user.name as String?
        
        screennameLabel.text = user.screenname as String?
        
        descriptionLabel.text = user.tagline as String?
        
        if let profileBackgroundURL = user.profileBackgroundUrl {
            profileBackgroundImageView.setImageWith(profileBackgroundURL as URL)
        }
        
        let followingCount = ("\(user.following_count) FOLLOWING")
        followingButton.setTitle(followingCount, for: .normal)
        
        let followerCount = ("\(user.followers_count) FOLLOWERS")
        followersButton.setTitle(followerCount, for: .normal)
        
        let tweetCount = ("\(user.tweet_count) TWEETS")
        tweetCountButton.setTitle(tweetCount, for: .normal)
    }
    
    func setProfileByTweet() {
        print("Profile being set by tweet")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
