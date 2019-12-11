//
//  Dog.swift
//  Name The Dog
//
//  Created by Keishin CHOU on 2019/12/11.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import Foundation
import RealmSwift

class Dog: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var image: Data? = nil

}
