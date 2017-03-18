//
//  MDBSocialsUtils.swift
//  Event Book
//
//  Created by Mark Siano on 2/28/17.
//  Copyright © 2017 Mark Siano. All rights reserved.
//

import Foundation
import UIKit

class MDBSocialsUtils {

    public var heightToWidthScalingFactor: CGFloat!
    var name: String!
    var imageHeight = CGFloat(200)   //Height of image in collection view cell
    var imageWidth: CGFloat!    //Width of image in collection view cell
    var spacing: CGFloat! //Vertical spacing between elements in collection view cell (in pixels)
    var postCollectionView: UICollectionView!
    var posts: [Post] = []
    
    var isFaved = [Bool]()
    
    init(name: String) {
        self.name = name
        spacing = 5.0
    }

}

var mainInstance = MDBSocialsUtils(name: "Utils Class")
