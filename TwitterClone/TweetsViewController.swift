//
//  TweetsViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/5/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //property that stores all the tweets
    var tweets: [Tweet]!
    
    //tableview outlet
    @IBOutlet weak var tableView: UITableView!
    
    //viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up tableview
        tableView.dataSource = self
        tableView.delegate = self
        
        //Tells the table to follow the auto-layout constraint rules
        tableView.rowHeight = UITableViewAutomaticDimension
        //Estimated for the scrollHeight Dimension
        tableView.estimatedRowHeight = 300
        
        //Used staredInstance to access homeTimeline method
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            
            //Stored the tweets within the class property
            self.tweets = tweets
            
            //reloads data to have in tableview
            self.tableView.reloadData()
            
            //Error
        }, failure: { (error: NSError) in
            print("TweetViewController" + error.localizedDescription)
        })
    }
    
    //onLogoutButton: when the logout button is pushed
    @IBAction func onLogoutButton(_ sender: Any) {
        
        //uses the sharedInstance to call logout()
        TwitterClient.sharedInstance?.logout()
        
    }
    
    //numberOfRowsInSection: lists the number of cells
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //the number of tweets
        return self.tweets?.count ?? 0
    }
    
    //cellForRowAt: the data to be stored within the cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //created a cell
        //used the "TweetCell" identifier in prototype cell and cast it as a TweetCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        //Got specific tweet that is necessary to put in
        let tweet = tweets?[indexPath.row]
        
        //Put tweet within the cell
        cell.tweet = tweet
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
