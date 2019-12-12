//
//  DetailViewController.swift
//  Name The Dog
//
//  Created by Keishin CHOU on 2019/12/12.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    let realm = try! Realm()
    var dogs: Results<Dog>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dogs = realm.objects(Dog.self)
        
        print(dogs.count)
        print(dogs.last?.identifier1)
        print(dogs.last?.confidence1)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
