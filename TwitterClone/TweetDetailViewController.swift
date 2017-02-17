//
//  TweetDetailViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/15/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var screennameButton: UIButton!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var directMessageButton: UIButton!
    
    //tweet that will be displayed
    var tweet: Tweet!

    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let description = tweet.favoritesCount
        
        print("\(description)")

        // Do any additional setup after loading the view.
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
