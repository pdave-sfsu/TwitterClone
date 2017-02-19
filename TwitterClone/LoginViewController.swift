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

//When the user needs to login
class LoginViewController: UIViewController {
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //onLoginButton action: when the login button is pushed
    @IBAction func onLoginButton(_ sender: Any) {
        
        //Uses shared instance to login from TwitterClient
        TwitterClient.sharedInstance?.login(success: {
            
            //Used the segue identifier to perform segue to Navigationbar
            //Goes to the TweetsViewController
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
            //Error
        }) { (error: NSError) in
            print("LoginViewController/onLoginButton() Error: \(error.localizedDescription)")
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
