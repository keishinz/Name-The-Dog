//
//  DetailViewController.swift
//  Name The Dog
//
//  Created by Keishin CHOU on 2019/12/12.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage
import Charts
import SDWebImage
import TinyConstraints

class DetailViewController: UIViewController {
    
    let realm = try! Realm()
    var dogs: Results<Dog>!
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }()
    
    lazy var graphView: PieChartView = {
        let graphView = PieChartView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        
        return graphView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    lazy var bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return bodyLabel
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(scrollView)
        setScrollView()
        
        scrollView.addSubview(contentView)
        setContentView()
        
        contentView.addSubview(graphView)
        setGraphView()
        
        contentView.addSubview(imageView)
        setImageView()
        
        contentView.addSubview(titleLabel)
        setTitleLabel()
        
        contentView.addSubview(bodyLabel)
        setBodyLabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dogs = realm.objects(Dog.self)
        
        print(dogs.count)
        print(dogs.last?.identifier1)
        print(dogs.last?.confidence1)
        print(dogs.last?.wikiImageURL)
        
        if let dog = dogs.last {
            let url = dog.wikiImageURL
            imageView.sd_setImage(with: URL(string: url), completed: nil)
            
            titleLabel.text = dog.identifier1
            bodyLabel.text = dog.dogDescription

        }
        
        
    }
    
    func setScrollView() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func setContentView() {
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: view.heightAnchor)
        contentViewHeightConstraint.isActive = true
        contentViewHeightConstraint.priority = UILayoutPriority(rawValue: 250)
    }
    
    func setGraphView() {
        graphView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        graphView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        graphView.center.x = contentView.center.x
        
        graphView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        graphView.widthAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func setImageView() {
        imageView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 10).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
//        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        imageView.contentMode = .scaleAspectFit
        
    }
    
    func setTitleLabel() {
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    func setBodyLabel() {
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        
        bodyLabel.numberOfLines = 0
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {
            var contentRect = CGRect.zero

            for view in self.scrollView.subviews {
               contentRect = contentRect.union(view.frame)
            }

            self.scrollView.contentSize = contentRect.size
        }
    }
    
}
