//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/5/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit
//import BDBOAuth1Manager
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //onLoginButton action: when the login button is pushed
    @IBAction func onLoginButton(_ sender: Any) {
        
        //Uses shared instance to login from TwitterClient
        TwitterClient.sharedInstance?.login(success: {
            
            print("onLoginButton: I've logged in!")
            
            //Used the segue identifier to perform segue to Navigationbar
            //Goes to the TweetsViewController/HomeTimeline
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
        
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
        
    }
}
