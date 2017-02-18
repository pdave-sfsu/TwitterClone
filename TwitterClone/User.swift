//
//  User.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/5/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

//User model is type NSObject
class User: NSObject {
    
    //properties that are within the user
    var name: NSString?
    var screenname: NSString?
    var tagline: NSString?
    var profileUrl: NSURL?
    var profileBackgroundUrl: NSURL?
    var followers_count: Int = 0
    var following_count: Int = 0
    var tweet_count: Int = 0
    
    //property that stores the user dictionary
    var dictionary: NSDictionary?
    
    //De-serializing dictionary and storing the values in corresponding properties
    init(dictionary: NSDictionary) {
        
        //Setting class dictionary to constructor dictionary
        self.dictionary = dictionary
        
        //Set the name, screenname, and tagline of the properties
        name = dictionary["name"] as! NSString?
        screenname = dictionary["screen_name"] as! NSString?
        tagline = dictionary["description"] as! NSString?
        
        print(tagline)
        
        //Retrieve profile pic url
        let profileUrlString = dictionary["profile_image_url_https"] as! NSString?
        
        //safely unwrap and set the profile URL
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString as String)
        }
        
        let profileBackgroundUrlString = dictionary["profile_background_image_url_https"] as! NSString?
        
        if let profileBackgroundUrlString = profileBackgroundUrlString {
            profileBackgroundUrl = NSURL(string: profileBackgroundUrlString as String)
        }
        
        followers_count = (dictionary["followers_count"] as? Int) ?? 0
        
        following_count = (dictionary["friends_count"] as? Int) ?? 0
        
        tweet_count = (dictionary["statuses_count"] as? Int) ?? 0
        
        print(tweet_count)
        
    }
    
    //UserDidLogoutNotification property
    static let userDidLogoutNotification = "UserDidLogout"
    
    //Stores the current user
    static var _currentUser: User?
    
    //class variable to get and set the current user; may be nil
    class var currentUser: User? {
        
        get {
            if _currentUser == nil {
                
                //userDefault to store the value of current user across restarts
                let userDefault = UserDefaults.standard
                
                //retrieve the previous current user
                let userData = userDefault.object(forKey: "currentUserData") as? Data
                
                //safely uwrap the userData
                if let userData = userData {
                    
                    //serializing the user data
                    if let dictionary = try? JSONSerialization.jsonObject(with: userData, options: .allowFragments){
                        
                        //setting the current user to stored user (in userDefaults)
                        _currentUser = User(dictionary: dictionary as! NSDictionary)
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            
            //Sets currentUser with new user
            _currentUser = user
            
            //initialize userDefaults
            let userDefault = UserDefaults.standard
            
            //Safely unwrapping user
            if let user = user {
                
                //Serializing the user
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])

                //Saving the userData with key in UserDefaults
                userDefault.set(data, forKey: "currentUserData")
            } else {
                
                //Saving nil with key in userDefaults
                userDefault.set(nil, forKey: "currentUserData")
            }
            
            //synchronize() method saves the data
            userDefault.synchronize()
        }
    }
}
