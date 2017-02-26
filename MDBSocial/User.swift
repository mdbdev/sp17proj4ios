//
//  User.swift
//  MDBSocial
//
//  Created by Levi Walsh on 2/25/17.
//  Copyright © 2017 Levi Walsh. All rights reserved.
//

import Foundation
import UIKit

class User {
    var name: String?
    var email: String?
    var imageUrl: String?
    var id: String?
    
    init(id: String, userDict: [String:Any]?) {
        self.id = id
        if userDict != nil {
            if let name = userDict!["name"] as? String {
                self.name = name
            }
            if let imageUrl = userDict!["imageUrl"] as? String {
                self.imageUrl = imageUrl
            }
            if let email = userDict!["email"] as? String {
                self.email = email
            }
        }
    }
}
