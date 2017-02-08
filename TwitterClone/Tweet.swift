//
//  Tweet.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/5/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    //Creating properties for all relevant data
    var text: String?
    var timestamp: Date?
    
    //Creating count properties, setting them to 0
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    //Saving the user that created the tweet
    var user: User?
    
    //Constructor that parses through the dictionary
    init(dictionary: NSDictionary) {
        
        //Initializing the user
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        //Retrieving the text
        text = dictionary["text"] as? String
        
        //Retrieving the count
        //If nil, then the value is 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        //Retrieving timestamp as String
        let timestampString = dictionary["created_at"] as? String
        
        //Safely unwrapping the timestampString
        if let timestampString = timestampString {
            
            //Declaring Dateformatter()
            let formatter = DateFormatter()
            
            //set the format for the date
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            //format the timestampString using the dateFormatter()
            timestamp = formatter.date(from: timestampString)
        }
    }
    
    //Adds individual tweets to array and sends them back
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        
        //Created an array of Tweet
        var tweets = [Tweet]()
        
        //Go through each dictionary to add to array
        for dictionary in dictionaries {
            
            //Initialize the Tweet and store it in tweet
            let tweet = Tweet(dictionary: dictionary)
            
            //Add to array tweets
            tweets.append(tweet)
        }
        
        return tweets
    }
}
