//
//  TwitterClient.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/5/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit
//import BDBOAuth1Manager
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    //sharedInstance that retrieves the token?
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "CukeG6YKF0u6uket3CmxofTbb", consumerSecret: "45j81J9aXtvYzt4IItnJerObWaBGuCXJQbUeJyaZNb3pCZYdoG")
    
    //
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    //login function is called when the user is first logging in
    func login (success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        
        //
        loginSuccess = success
        loginFailure = failure
        
        //deauthorize is used to log out of the existing account
        deauthorize()
        
        //fetchRequestToken: recieves the request token
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterdemo://oaut"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("I got a token: \(requestToken!.token!)")
            
            //Creates the URL
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            
            //Opens the sign in page on Safari
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            //Error
        }, failure: { (error: Error?) -> Void in
            print(" error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
    }
    
    //logout method: lets the user logout
    func logout() {
        
        //Sets the current user to nil
        User.currentUser = nil
        
        //signs out the existing account
        deauthorize()
        
        //
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    //handleOpenURL: logic for when app returns back from authorization verification
    func handleOpenUrl(url: NSURL) {
        
        //
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        //fetchAccessToken: fetches the access token
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("I got the access token: \(accessToken!.token)!")
            
            //Retrieves the current account
            self.currentAccount(success: { (user: User) in
                
                //sets the currentUser
                User.currentUser = user
                
                self.loginSuccess?()
            
                //Error
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
            //Error
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
    }
    
    //homeTimeline: Retrieves the texts from the hometimeline
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        
        //gets the tweets in dictionary array format
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            //response is force cast and saved as an array of dictionaries
            let dictionaries = response as! [NSDictionary]
            
            //tweets are sent to tweetsWithArray to be parsed and sent back
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            //
            success(tweets)
        
            //Error
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    //currentAccount: figures out the current account
    func currentAccount (success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        
        //gets a dictionary representing the current user
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            //userDictionary stores the current user
            let userDictionary = response as! NSDictionary
            
            //userDictionary is parsed in User model
            let user = User(dictionary: userDictionary)
            
            //
            success(user)
            
            //Error
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
}
