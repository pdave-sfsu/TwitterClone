//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/17/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

//ProfileViewContoller is the profileView
class ProfileViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var tweetCountButton: UIButton!
    @IBOutlet weak var composeTweet: UIButton!
    
    //Future use for profileImageButton
    @IBOutlet weak var profileImageView: UIImageView!

    //user property
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Since screenname is unique identifier, it is used as a key
        //If it is the current user, then show composeTweet button
        //Useful if user clicks on their own profile picture in the hometimeline
        if user.screenname != User._currentUser?.screenname {
            composeTweet.isHidden = true
        } else {
            composeTweet.isHidden = false
        }
        
        //sets the Profile
        setProfile()
        
    }
    
    
    //Sets the profile
    func setProfile() {
        
        if let profileURL = user.profileUrl {
            profileImageView.setImageWith(profileURL as URL)
        }
        
        if let profileBackgroundURL = user.profileBackgroundUrl {
            profileBackgroundImageView.setImageWith(profileBackgroundURL as URL)
        }
        
        nameLabel.text = user.name as String?
        screennameLabel.text = user.screenname as String?
        descriptionLabel.text = user.tagline as String?
        
        //sets the counts
        //Future: Set the plurality of tweets and followers
        let followingCount = ("\(user.following_count) FOLLOWING")
        followingButton.setTitle(followingCount, for: .normal)
        
        let followerCount = ("\(user.followers_count) FOLLOWERS")
        followersButton.setTitle(followerCount, for: .normal)
        
        let tweetCount = ("\(user.tweet_count) TWEETS")
        tweetCountButton.setTitle(tweetCount, for: .normal)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
