//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Poojan Dave on 2/5/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "CukeG6YKF0u6uket3CmxofTbb", consumerSecret: "45j81J9aXtvYzt4IItnJerObWaBGuCXJQbUeJyaZNb3pCZYdoG")
        
        twitterClient?.deauthorize()
        
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterdemo://oaut"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("I got a token: \(requestToken!.token!)")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error?) -> Void in
            print(" error: \(error?.localizedDescription)")
        })
        
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
