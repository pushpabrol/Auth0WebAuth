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
                
            welcomeText.text = "Hi " + ( (jwt.body["email"] != nil ? jwt.body["email"] : jwt.body["name"])  as! String!) + ""
            
                        accessToken.text = "This is a sample app. You have successfuly logged into Auth0 and now have an access_token to invoke API with audience: " + Application.sharedInstance.API_AUDIENCE! + ". You also have been granted a refresh token which means on closing and opening this app you will not have to sign in again. The refresh token will be used to get a new id_token and access_token."
            
            if (jwt.body["picture"] != nil)
            
            {
            URLSession.shared.dataTask(with: URL(string : jwt.body["picture"] as! String)!, completionHandler: { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data , error == nil else { return }
                    self.profileImage.image = UIImage(data: data)

                }
            }).resume()
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
            let alertController = UIAlertController(title: "JWT Decode error", message:
                error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }

        
    }
    @IBOutlet weak var profileImage: UIImageView!
    
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
        A0SimpleKeychain().clearAll()
        
        let alertController = UIAlertController(title: "Logout", message:
            "Deleting tokens for now. SSO still exists..", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: {(alert: UIAlertAction) in
            self.performSegue(withIdentifier: "loginView", sender: self)
            
        
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
        
        

        
    }
}

