//
//  DogCardViewController.swift
//  Name The Dog
//
//  Created by Keishin CHOU on 2019/12/15.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import CardSlider
import RealmSwift

class DogCardViewController: UIViewController {
    
    let realm = try! Realm()
    var dogs: Results<Dog>!
    var dogCards = [DogCard]()
    var dogCard = DogCard()
    
    override func loadView() {
        super.loadView()
        
        dogs = realm.objects(Dog.self)
        
        var confidence: Double
        
        for dogIndex in 0 ..< dogs.count {
            dogCard.image = UIImage(data: dogs[dogIndex].image!)
            dogCard.title = dogs[dogIndex].name
            dogCard.subtitle = String(dogs[dogIndex].confidence1.rounded(toPlaces: 1.0))
            dogCard.description = dogs[dogIndex].dogDescription
            
            confidence = dogs[dogIndex].confidence1.rounded(toPlaces: 1.0)
            dogCard.rating = Int(confidence / 20.0) + 1
            
            dogCards.append(dogCard)
        }        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let cardSlider = CardSliderViewController.with(dataSource: self)
        cardSlider.title = "Dog Library"
        cardSlider.modalPresentationStyle = .automatic
        cardSlider.modalTransitionStyle = .coverVertical
        present(cardSlider, animated: true, completion: nil)
    }

}

//extension Double {
//    /// Rounds the double to decimal places value
//    func rounded(toPlaces places: Double) -> Double {
//        return (self * places * 1000).rounded() / 10
//    }
//}

extension DogCardViewController: CardSliderDataSource {
    func item(for index: Int) -> CardSliderItem {
        return dogCards[index]
    }
    
    func numberOfItems() -> Int {
        return dogCards.count
    }
    
    
}

