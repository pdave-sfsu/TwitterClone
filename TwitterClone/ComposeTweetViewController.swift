//
//  ComposeTweetViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/18/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var tweetCharacterCountLabel: UILabel!
    @IBOutlet weak var tweetSendButton: UIButton!
    
    var replyUser: User!
    var isReply: Bool = false
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isReply {
            tweetTextView.text = "@\(replyUser.screenname as! String)"
        }
    }

    @IBAction func sendTweetButtonPressed(_ sender: Any) {
        
        print("SendTweetButtonPressed")
        
        if isReply {
            
            var escapedTweetMessage = tweetTextView.text!
            
            escapedTweetMessage = escapedTweetMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            TwitterClient.sharedInstance?.reply(escapedTweetMessage, statusID: Int(tweet.idStr)!, params: nil, completion: {
                (error) -> () in
                print("replying")
            })
            
            print("reply")
            
            isReply = false
            
        } else {
            
            var escapedTweetMessage = tweetTextView.text!
            
            escapedTweetMessage = escapedTweetMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            TwitterClient.sharedInstance?.compose(escapedTweetMessage, params: nil, completion: { (error) -> () in
                print("composing tweet")
            })
            
        }
        
        
        
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
