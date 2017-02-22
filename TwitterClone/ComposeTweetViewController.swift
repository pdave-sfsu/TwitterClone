//
//  ComposeTweetViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/18/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

//ComposeTweetViewController for replies and new tweets
class ComposeTweetViewController: UIViewController {

    //outlets
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetCharacterCountLabel: UILabel!
    @IBOutlet weak var tweetSendButton: UIButton!
    
    //isReply property
    var isReply: Bool = false
    
    //tweet property
    var tweet: Tweet!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adds the @screenname of the user being replied to
        if isReply {
            tweetTextView.text = "@\(tweet.user?.screenname as! String)"
        }
    }

    
    //Action for sendTweetButtonPressed
    @IBAction func sendTweetButtonPressed(_ sender: Any) {
        
        //retrieve the text from textView
        var escapedTweetMessage = tweetTextView.text!
        
        //
        escapedTweetMessage = escapedTweetMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        //If isReply is true, then send as reply
        //Else: Compose an original tweet
        if isReply {
            
            //Used sharedInstance to send reply
            //passed in the text for tweet and the tweet id for original tweet
            TwitterClient.sharedInstance?.reply(escapedTweetMessage, statusID: tweet.idStr, params: nil, completion: {
                
                //
                (error) -> () in
                
                print("ComposeTweetViewController/sendTweetButtonPressed(): reply tweet")
                
            })
            
            //setting isReplying to false
            isReply = false
            
        } else {
            
            //Using shared instance to compose original tweet
            //passed in the text
            TwitterClient.sharedInstance?.compose(escapedTweetMessage, params: nil, completion:
                
                //
                { (error) -> () in
                
                print("ComposeTweetViewController/sendTweetButtonPressed(): composed tweet")
            })
            
        }
        
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
