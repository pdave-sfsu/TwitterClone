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
            
            print("TwitterClient/login(): I got a token: \(requestToken!.token!)")
            
            //Creates the URL
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            
            //Opens the sign in page on Safari
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            //Error
        }, failure: { (error: Error?) -> Void in
            
            print("TwitterClient/login(): error: \(error?.localizedDescription)")
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
            
            print("TwitterClient/handleOpenUrl(): I got the access token: \(accessToken!.token)!")
            
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
            
            print("TwitterClient/handleOpenUrl(): error: \(error?.localizedDescription)")
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
            
            print("TwitterClient/currentAccount():screenname \(user.screenname)")
            
            //Error
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    //createFavorite method lets the user favorite a tweet
    func createFavorite (params: NSDictionary?, success: @escaping (_ tweet: Tweet?) -> (), failure: @escaping (Error) -> ()){
        
        //sends the request to favorite the tweet
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
            
            //returns a new tweet
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            //
            success(tweet)
            
            //Error
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    //destoryFavorite method lets the user unfavorite a tweet
    func destoryFavorite(params: NSDictionary?, success: @escaping (_ tweet: Tweet?) -> (), failure: @escaping (Error) -> ()) {
        
        //sends the request to unfavorite the tweet
        post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task:  URLSessionDataTask, response: Any) -> Void in
            
            //returns a new tweet
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            //
            success(tweet)
            
            //Error
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    //createRetweet lets the user retweet
    func createRetweet (id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        
        //sends the request to favorite the tweet and passes in the "id"
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask!, response: Any) -> Void in
            
            //
            success()
            
            //Error
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("Couldn't retweet")
            failure(error)
        })
    }
    
    //destroyRetweet lets the user unretweet
    func destroyRetweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> () ){
        
        //send the request to unretweet and passed in the "id"
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            
            //
            success()
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Couldn't unretweet")
            failure(error!)
        })
    }
    
    func compose(_ escapedTweet: String, params: NSDictionary?, completion: @escaping (_ error: Error?) -> () ){
        post("1.1/statuses/update.json?status=\(escapedTweet)", parameters: params, success: { (operation: URLSessionDataTask, response: Any?) -> Void in
            print("tweeted: \(escapedTweet)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error!) -> Void in
            print ("could not compose tweet")
            completion(error)
        }
        )
    }
    
    func reply(_ escapedTweet: String, statusID: Int, params: NSDictionary?, completion: @escaping (_ error: Error?) -> () ){
        post("1.1/statuses/update.json?in_reply_to_status_id=\(statusID)&status=\(escapedTweet)", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("tweeted: \(escapedTweet)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error!) -> Void in
            print ("could not reply")
            completion(error)
        }
        )
    }
    
}
