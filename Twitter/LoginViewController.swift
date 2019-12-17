//
//  LoginViewController.swift
//  Twitter
//
//  Created by user160656 on 12/16/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var preferences = UserDefaults.standard
    @IBAction func onLogin(_ sender: Any) {
        let url = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: url, success: {
            self.preferences.set(true, forKey: "logged_in")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (error) in
            print("Could not login")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (preferences.bool(forKey: "logged_in") == true) {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
