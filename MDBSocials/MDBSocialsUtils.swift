//
//  MDBSocialsUtils.swift
//  MDBSocials
//
//  Created by Boris Yue on 3/1/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Foundation

class MDBSocialsUtils {
    
    static func clearCell(cell: UITableViewCell) {
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview() //remove stuff from cell before initializing
        }
    }
}
