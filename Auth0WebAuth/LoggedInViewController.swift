//
//  LoggedInViewController.swift
//  Auth0WebAuth
//
//  Created by Pushp Abrol on 11/2/16.
//  Copyright © 2016 Pushp Abrol. All rights reserved.
//

import UIKit
import SimpleKeychain
import Alamofire
import Auth0
import JWTDecode

class LoggedInViewController : UIViewController {
    
    @IBOutlet weak var welcomeText: UITextView!
    @IBOutlet weak var accessToken: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let jwt = try decode(jwt: A0SimpleKeychain().string(forKey: "idToken")!)
            print(jwt.audience?.first)
                        welcomeText.text = "Hi " + (jwt.body["name"] as! String!) + ""
            
                        accessToken.text = "You have successfuly logged into Auth0 and now have an access_token for API with audience: " + Application.sharedInstance.API_AUDIENCE! + ". You also have been granted an access token which means on closing and opening this app you will not have to sign in again"
        }
        catch let error as NSError {
            print(error.localizedDescription)
            let alertController = UIAlertController(title: "JWT Decode error", message:
                error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func invokeApi(_ sender: AnyObject) {
        let app = Application.sharedInstance
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + A0SimpleKeychain().string(forKey: "accessToken")!        ]
        Alamofire.request(app.securePingURL.absoluteString!, headers:headers).responseString { response in
            print("Success: \(response.result.isSuccess)")
            if(response.result.isSuccess)
            {
            print("Response String: \(response.result.value)")
            let alertController = UIAlertController(title: "Secure API message", message:
                response.result.value, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                let alertController = UIAlertController(title: "Secure API message", message:
                    response.result.error.debugDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)

            }
        }
        
        

    }
        
    @IBAction func logout(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Logout", message:
            "Coming soon...", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)

        
    }
}
