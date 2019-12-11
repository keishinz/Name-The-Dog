//
//  HistoryCollectionViewController.swift
//  Name The Dog
//
//  Created by Keishin CHOU on 2019/12/10.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit

import RealmSwift

private let reuseIdentifier = "Dog"
//internal var dogs = [Dog]()

class HistoryCollectionViewController: UICollectionViewController {
    
    enum Mode {
        case view
        case select
    }

    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                collectionView.allowsSelection = false
                collectionView.allowsMultipleSelection = false
            case .select:
                collectionView.allowsSelection = true
                collectionView.allowsMultipleSelection = true
            }
        }
    }

    var dictionaryDidSelect: [IndexPath : Bool] = [:]
    
    let realm = try! Realm()
    var dogs: Results<Dog>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        dogs = realm.objects(Dog.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dogs.count == 0 {
            title = "No photos here"
        } else {
            title = "Dog's photo library"
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItems))
        }
        
        collectionView.allowsSelection = false
        collectionView.allowsMultipleSelection = false
        collectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dogs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DogCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
    
        // Configure the cell
        let dog = dogs[indexPath.item]
        cell.dogName.text = dog.name
        
//        let path = getDocumentsDirectory().appendingPathComponent(dog.image)
//        cell.dogImage.image = UIImage(contentsOfFile: path.path)
        
        cell.dogImage.image = UIImage(data: dog.image!)
        
        cell.dogImage.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.dogImage.layer.borderWidth = 2
        cell.dogImage.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("didSelectItemAt\(indexPath)")
        dictionaryDidSelect[indexPath] = true
//        if mMode == .select{
//            dictionaryDidSelect[indexPath] = true
//            dictionaryDidSelect[indexPath] = dictionaryDidSelect[indexPath] == true ? false : true
//        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if mMode == .select{
//            dictionaryDidSelect[indexPath] = false
//        }
        print("didDeselectItemAt\(indexPath)")
        dictionaryDidSelect[indexPath] = false
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    @objc func editItems(_ sender: UIBarButtonItem) {
//        mMode = mMode == .view ? .select : .view
        mMode = .select
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelect))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItems))

        
    }
    
    @objc func deleteItems(_ sender: UIBarButtonItem) {
        var willDeleteItemIndexPaths: [IndexPath] = []
        for (key, value) in dictionaryDidSelect {
            if value == true {
                willDeleteItemIndexPaths.append(key)
            }
        }
        print(willDeleteItemIndexPaths)
        
        for i in willDeleteItemIndexPaths.sorted(by: {$0.item > $1.item}) {
//            dogs.remove(at: i.item)
            print(i)
            
            do {
                try realm.write {
                    realm.delete(dogs[i.item])
                }
            } catch {
                print("Error deleting dog \(error.localizedDescription)")
            }
        }
        
        collectionView.deleteItems(at: willDeleteItemIndexPaths)
        willDeleteItemIndexPaths.removeAll()
        
        mMode = .view
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItems))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "Trash"), style: .done, target: self, action: nil)
    }
    
    @objc func cancelSelect(_ sender: UIBarButtonItem) {
//        mMode = mMode == .select ? .view : .select
        mMode = .view
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItems))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "Trash"), style: .done, target: self, action: nil)

    }

}
