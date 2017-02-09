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
    
    //Creating the isFavorite and is Retweeted property
    var isFavorited: Bool = false
    var isRetweeted: Bool = false
    
    //Holds the id for the tweet
    var idStr: String
    
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
        
        //Figures out if favorited or retweeted by currentuser
        isFavorited = (dictionary["favorited"] as? Bool)!
        isRetweeted = (dictionary["retweeted"] as? Bool)!
        
        //Retrieves the id for the tweet
        idStr = (dictionary["id_str"] as? String)!
    }
    
    //Input: dictionaries of tweets
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
    
    //Input: 1 tweet as a dictionary
    class func tweetAsDictionary (_ dict: NSDictionary) -> Tweet {
        
        //tweet is parsed and initialized
        let tweet = Tweet(dictionary: dict)
        
        return tweet
    }
}
