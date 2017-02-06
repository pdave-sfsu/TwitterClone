//
//  User.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/5/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    
    init(dictionary: NSDictionary){
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as! NSString?
        screenname = dictionary["screen_name"] as! NSString?
        
        let profileUrlString = dictionary["profile_image_url_https"] as! NSString?
        
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString as String)
        }
        
        tagline = dictionary["description"] as! NSString?
        
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let userDefault = UserDefaults.standard
                let userData = userDefault.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try!
                        JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let userDefault = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                userDefault.set(data, forKey: "currentUserData")
            } else {
                userDefault.set(nil, forKey: "currentUserData")
            }
            
            userDefault.set(user, forKey: "currentUser")
            
            userDefault.synchronize()
        }
    }
    
}
