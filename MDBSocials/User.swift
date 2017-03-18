//
//  User.swift
//  FirebaseDemoWeek3
//
//  Created by Sahil Lamba on 2/17/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import Foundation
import UIKit

class User {
    var name: String?
    var email: String?
    var id: String!
    
    init(id: String, userDict: [String:Any]?) {
        self.id = id
        if userDict != nil {
            if let name = userDict!["name"] as? String {
                self.name = name
            }
            if let email = userDict!["email"] as? String {
                self.email = email
            }
            
        }
    }
    
    
}
