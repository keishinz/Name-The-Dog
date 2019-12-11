//
//  Dog.swift
//  Name The Dog
//
//  Created by Keishin CHOU on 2019/12/11.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit

class Dog: NSObject { // why not use a struct??

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
}
