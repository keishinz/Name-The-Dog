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

import GoogleMobileAds

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GADBannerViewDelegate {
    
    var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var bannerView: GADBannerView!

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
        
        title = "Name the Dog"
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(addPhoto))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(useCamera))
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
    }
    
    @objc func addPhoto() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func useCamera() {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
//            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSelectPhoto))
//            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.2.squarepath"), style: .plain, target: self, action: #selector(addPhoto))
            
            guard let ciimage = CIImage(image: image) else { return }
            doneSelectPhoto(using: ciimage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
//    @objc func doneSelectPhoto() {
//
//        guard let ciimage = CIImage(image: imageView.image!) else { return }
//        detect(using: ciimage)
//    }
    
    func doneSelectPhoto(using image: CIImage) {
        
        guard let mlModel = try? VNCoreMLModel(for: DogIdentifier2().model) else {
            fatalError()
        }
        
        let request = VNCoreMLRequest(model: mlModel) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            if let firstResult = results.first {
                print(firstResult.identifier)
                print(firstResult.confidence)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    func detect(using image: CIImage) {
        
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

