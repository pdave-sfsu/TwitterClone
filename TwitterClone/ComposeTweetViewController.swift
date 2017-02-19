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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sendTweetButtonPressed(_ sender: Any) {
        
        print("SendTweetButtonPressed")
        
        var escapedTweetMessage = tweetTextView.text!
        
        escapedTweetMessage = escapedTweetMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        TwitterClient.sharedInstance?.compose(escapedTweetMessage, params: nil, completion: { (error) -> () in
            print("composing tweet")
        })
        
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
