//
//  ViewController.swift
//  Name The Dog
//
//  Created by Keishin CHOU on 2019/12/09.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import CoreML
import UIKit
import Vision
import SafariServices

import Alamofire
import AlamofireImage
import GoogleMobileAds
import NVActivityIndicatorView
import RealmSwift
import SVProgressHUD
import SwiftyJSON

class ViewController: UIViewController, NVActivityIndicatorViewable {
    
    var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var wikiTitle: String?
//    var imageDocName: String?
    
    let realm = try! Realm()
    
    var dogs = [Dog]()
    var identifier1: String?
    var confidence1: Double?
    var identifier2: String?
    var confidence2: Double?
    var identifier3: String?
    var confidence3: Double?
    var identifier4: String?
    var confidence4: Double?
    var identifier5: String?
    var confidence5: Double?
    var dogDescription: String?
//    var wikiImage: UIImage?
    var wikiImageURL: String?


    override func loadView() {
        
        view = UIView()
        imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "DogBackground")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Name the Dog"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(addPhoto))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(useCamera))
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.load(GADRequest())
        interstitial = createAndLoadInterstitial()
        interstitial.delegate = self
    }
    
    @objc func addPhoto() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func useCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera is not available.")
        }
    }
    
    @objc func doneSelectPhoto() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }

    }
    
    //MARK: Detecting CoreML
    func detectImage(using image: CIImage) {
        
//        SVProgressHUD.show()
//        startAnimating()
//        startAnimating(CGSize(width: 80, height: 80), message: "Analyzing Photo", type: .ballScaleRippleMultiple, displayTimeThreshold: 5)
//        startAnimating(<#T##size: CGSize?##CGSize?#>, message: <#T##String?#>, messageFont: <#T##UIFont?#>, type: <#T##NVActivityIndicatorType?#>, color: <#T##UIColor?#>, padding: <#T##CGFloat?#>, displayTimeThreshold: <#T##Int?#>, minimumDisplayTime: <#T##Int?#>, backgroundColor: <#T##UIColor?#>, textColor: <#T##UIColor?#>, fadeInAnimation: <#T##FadeInAnimation?##FadeInAnimation?##(UIView) -> Void#>)
        
        guard let mlModel = try? VNCoreMLModel(for: DogIdentifier2().model) else {
            fatalError()
        }
        
        let request = VNCoreMLRequest(model: mlModel) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            self.identifier1 = results[0].identifier
            self.confidence1 = Double(results[0].confidence)
            self.identifier2 = results[1].identifier
            self.confidence2 = Double(results[1].confidence)
            self.identifier3 = results[2].identifier
            self.confidence3 = Double(results[2].confidence)
            self.identifier4 = results[3].identifier
            self.confidence4 = Double(results[3].confidence)
            self.identifier5 = results[4].identifier
            self.confidence5 = Double(results[4].confidence)


            
            if let firstResult = results.first {
//                print(firstResult.identifier)
//                print(firstResult.confidence)
                
                let parameters : [String:String] = [
                    "format": "json",
                    "action": "query",
                    "prop": "extracts|pageimages",
                    "exintro": "",
                    "explaintext": "",
                    "titles": firstResult.identifier,
                    "indexpageids": "",
                    "redirects": "1",
                    "pithumbsize": "500"
                ]
                
                self.getWikiInfomation(url: self.wikipediaURl, parameters: parameters)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        
    }
    
    //MARK: Querying Wiki
    func getWikiInfomation(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        print("Success! Got the wiki info.")
                        print(response.result)
                        
                        let wikiJSON: JSON = JSON(response.result.value!)
                        let pageid = wikiJSON["query"]["pageids"][0].stringValue
                        let description = wikiJSON["query"]["pages"][pageid]["extract"].stringValue
                        let wikiImageURL = wikiJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                        self.wikiTitle = wikiJSON["query"]["pages"][pageid]["title"].stringValue
                        
                        print(wikiJSON)
                        print(pageid)
                        print(description)
                        print(wikiImageURL)
                        print(self.wikiTitle!)
                        
                        self.dogDescription = description
                        self.wikiImageURL = wikiImageURL
//                        self.wikiImage =
//                        self.grapWikiImage(with: wikiImageURL)
                        
                        self.performNavigation()
                        
                    } else {
                        print("Error \(String(describing: response.result.error))")
                    }
                }
    }
    
//    func grapWikiImage(with wikiImageURL: String) {
//        if wikiImageURL == "" {
//            return
//        } else {
//            Alamofire.request(URL(string: wikiImageURL)!).responseImage { response in
////                debugPrint(response)
////
////                print(response.request!)
////                print(response.response!)
////                debugPrint(response.result)
//
//                if let image = response.result.value {
////                    print("image downloaded: \(image)")
//                    self.wikiImage = image
////                    self.imageView.image = image
//                }
//            }
//        }
//
//        performNavigation()
//    }
    
    func performNavigation() {
        
//        SVProgressHUD.dismiss()
//        loadingAcitivity?.stopAnimating()
        
        let dog = Dog()
        dog.name = identifier1!
        dog.image = imageView.image?.jpegData(compressionQuality: 0.8)
        dog.identifier1 = identifier1!
        dog.confidence1 = confidence1!
        dog.identifier2 = identifier2!
        dog.confidence2 = confidence2!
        dog.identifier3 = identifier3!
        dog.confidence3 = confidence3!
        dog.identifier4 = identifier4!
        dog.confidence4 = confidence4!
        dog.identifier5 = identifier5!
        dog.confidence5 = confidence5!
        dog.dogDescription = dogDescription!
//        dog.wikiImage = wikiImage?.jpegData(compressionQuality: 1)
        dog.wikiImageURL = wikiImageURL!
        dogs.append(dog)
        
        try! realm.write {
            realm.add(dog)
        }
        
        stopAnimating()
        
        performSegue(withIdentifier: "ShowDetailSegue", sender: nil)
        
//        if pageid == "-1" {
////            wikiTitle = wikiTitle?.replacingOccurrences(of: " ", with: "%20")
////            print(wikiTitle!)
//
//            if let url = URL(string: "https://www.google.com/search?q=\(wikiTitle!.replacingOccurrences(of: " ", with: "%20"))") {
//                print(url)
//
//                let config = SFSafariViewController.Configuration()
//                config.entersReaderIfAvailable = true
//
//                let vc = SFSafariViewController(url: url, configuration: config)
//                vc.delegate = self
//                present(vc, animated: true, completion: nil)
//            } else {
//                print("Dont exist!")
//            }
//        } else {
//
////            wikiTitle = wikiTitle?.replacingOccurrences(of: " ", with: "_")
////            print(wikiTitle!)
//
//            if let url = URL(string: "https://en.wikipedia.org/wiki/\(wikiTitle!.replacingOccurrences(of: " ", with: "_"))") {
//                print(url)
//
//                let config = SFSafariViewController.Configuration()
//                config.entersReaderIfAvailable = true
//
//                let vc = SFSafariViewController(url: url, configuration: config)
//                vc.delegate = self
//                present(vc, animated: true, completion: nil)
//            } else {
//                print("Dont exist!")
//            }
//        }
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints([NSLayoutConstraint(item: bannerView,
                                                attribute: .bottom,
                                                relatedBy: .equal,
//                                                  toItem: bottomLayoutGuide,
                                                toItem: view.safeAreaLayoutGuide,
//                                                  attribute: .top,
                                                attribute: .bottom,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: bannerView,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .centerX,
                                                multiplier: 1,
                                                constant: 0)
        ])
     }
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate Methods
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
//            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSelectPhoto))
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Analyze", style: .plain, target: self, action: #selector(doneSelectPhoto))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.2.squarepath"), style: .plain, target: self, action: #selector(addPhoto))
            
            //Saving image into document directory
//            let imageName = UUID().uuidString
//            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
//            imageDocName = imageName
//
//            if let jpegData = image.jpegData(compressionQuality: 0.8) {
//                try? jpegData.write(to: imagePath)
//            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: SFSafariViewControllerDelegate Methods
//extension ViewController: SFSafariViewControllerDelegate {
//    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//        dismiss(animated: true)
//
////        if interstitial.isReady {
////            interstitial.present(fromRootViewController: self)
////        }
//
////        let dog = Dog(name: wikiTitle!, image: imageDocName!)
//
//    }
//}

//MARK: GADBannerViewDelegate Methods
extension ViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        print("adViewDidReceiveAd")
        
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform

        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}

//MARK: GADInterstitialDelegate Methods
extension ViewController: GADInterstitialDelegate {
    func createAndLoadInterstitial() -> GADInterstitial {
          let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
          interstitial.delegate = self
          interstitial.load(GADRequest())
          return interstitial
    }

    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        print("interstitialDidDismissScreen")
        
        startAnimating(CGSize(width: 80, height: 80), message: "Analyzing Photo", type: .ballScaleRippleMultiple, displayTimeThreshold: 5)
        
        guard let ciimage = CIImage(image: imageView.image!) else { return }
        detectImage(using: ciimage)
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }
}

internal func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

