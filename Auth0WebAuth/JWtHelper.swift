//
//  JWtHelper.swift
//  Auth0WebAuth
//
//  Created by Pushp Abrol on 11/5/16.
//  Copyright © 2016 Pushp Abrol. All rights reserved.
//

import Foundation
import JWTDecode

class JWtHelper {

    static func isTokenValid(token : JWT) -> Bool {
        let app = Application.sharedInstance
        return (app.audience! == token.audience?.first) && (token.issuer == "https://" + app.domain! + "/") && !token.expired
        
    }

}
