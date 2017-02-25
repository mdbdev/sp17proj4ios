//
//  User.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/24/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Foundation

class User {
    var name: String?
    var email: String?
    var username: String?
    var id: String?
    
    init(id: String, userDict: [String:Any]?) {
        self.id = id
        if userDict != nil {
            if let name = userDict!["name"] as? String {
                self.name = name
            }
            if let email = userDict!["email"] as? String {
                self.email = email
            }
            if let username = userDict!["username"] as? String {
                self.username = username
            }
        }
    }
}
