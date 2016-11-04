//
//  ViewController.swift
//  Auth0WebAuth
//
//  Created by Pushp Abrol on 11/2/16.
//  Copyright © 2016 Pushp Abrol. All rights reserved.
//

import UIKit
import Auth0
import SimpleKeychain
import JWTDecode
import Alamofire


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (A0SimpleKeychain().string(forKey: "refreshToken") != nil)
        {
            getTokens(fromRefreshToken: A0SimpleKeychain().string(forKey: "refreshToken")! )
            self.performSegue(withIdentifier: "loggedin", sender: self)
            
            
            
        }
        
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickOnLogin(_ sender: AnyObject) {
          let app = Application.sharedInstance
        var auth0 = Auth0.webAuth()
        
        auth0
            .logging(enabled: true)
            .parameters(["audience" : app.API_AUDIENCE!, "device" : "Pushp"])
            .scope(app.scope!)
            .start { result in
                switch result {
                case .success(let credentials):
                    print("credentials: \(credentials)")
                    do {
                    let jwt = try decode(jwt: credentials.idToken!)
                        print(jwt.audience?.first)
                        if(app.audience! == jwt.audience?.first && jwt.issuer == "https://" + app.domain! + "/")
                        {
                            A0SimpleKeychain().setString(credentials.accessToken, forKey: "accessToken")
                            A0SimpleKeychain().setString(credentials.idToken!, forKey: "idToken")
                            A0SimpleKeychain().setString(credentials.refreshToken!, forKey: "refreshToken")
                            self.performSegue(withIdentifier: "loggedin", sender: self)
                        }
                        else
                        {
                            print("JWT Validation failed on audience check");
                            let alertController = UIAlertController(title: "JWT Validation", message:
                                "JWT Validation failed on audience check", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    catch let error as NSError {
                        print(error.localizedDescription)
                        let alertController = UIAlertController(title: "JWT Decode error", message:
                            error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
 

                case .failure(let error):
                    print(error)
                    let alertController = UIAlertController(title: "Error logging in", message:
                        error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
        }

    }
    
    func callAPI() {
   
            }
    
    func getTokens(fromRefreshToken: String){
        let app = Application.sharedInstance
        
        let parameters: [String: Any] = [
            "refresh_token" : fromRefreshToken,
            "client_id" : app.audience! as String,
            "grant_type" : "refresh_token"
 
        ]
        let url =  "https://".appending(app.domain!).appending("/oauth/token")
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                case .success:
                if let result = response.result.value {
                 let JSON = result as! NSDictionary
                    A0SimpleKeychain().setString(JSON.value(forKey: "access_token") as! String, forKey: "accessToken")
                    A0SimpleKeychain().setString(JSON.value(forKey: "id_token") as! String, forKey: "idToken")

                }
                case .failure(let error):
                    print(error)
                    let alertController = UIAlertController(title: "Error refreshing tokens", message:
                        error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
        }
        
    
    }

}

