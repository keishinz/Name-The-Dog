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
    @objc dynamic var identifier1: String = ""
    @objc dynamic var confidence1: Double = 0.0
    @objc dynamic var identifier2: String = ""
    @objc dynamic var confidence2: Double = 0.0
    @objc dynamic var identifier3: String = ""
    @objc dynamic var confidence3: Double = 0.0
    @objc dynamic var identifier4: String = ""
    @objc dynamic var confidence4: Double = 0.0
    @objc dynamic var identifier5: String = ""
    @objc dynamic var confidence5: Double = 0.0
    @objc dynamic var dogDescription: String = ""
//    @objc dynamic var wikiImage: Data? = nil
    @objc dynamic var wikiImageURL: String = ""

}
