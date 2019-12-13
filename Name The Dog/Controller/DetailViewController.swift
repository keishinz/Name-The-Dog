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
    
    var identifier1 = ""
    var confidence1 = 0.0
    var identifier2 = ""
    var confidence2 = 0.0
    var identifier3 = ""
    var confidence3 = 0.0
    var identifier4 = ""
    var confidence4 = 0.0
    var identifier5 = ""
    var confidence5 = 0.0
    
    var dataEntry1 = PieChartDataEntry(value: 0)
    var dataEntry2 = PieChartDataEntry(value: 0)
    var dataEntry3 = PieChartDataEntry(value: 0)
    var dataEntry4 = PieChartDataEntry(value: 0)
    var dataEntry5 = PieChartDataEntry(value: 0)
    let otherDataEntry = PieChartDataEntry(value: 0)
    
    var dataSet = [PieChartDataEntry]()
    
    
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .lightGray
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
            
//            identifier1 = dog.identifier1
//            confidence1 = Double(round(10 * dog.confidence1 ) / 10)
//            confidence1 = dog.confidence1.rounded(toPlaces: 1)
//            identifier2 = dog.identifier2
//            confidence2 = dog.confidence2.rounded(toPlaces: 1)
//            identifier3 = dog.identifier3
//            confidence3 = dog.confidence3.rounded(toPlaces: 1)
//            identifier4 = dog.identifier4
//            confidence4 = dog.confidence4
//            identifier5 = dog.identifier5
//            confidence5 = dog.confidence5
            
//            graphView.chartDescription?.text = "The dog's breed seems to be..."
//            graphView.chartDescription?.textColor = .label
            dataEntry1.label = dog.identifier1
            dataEntry1.value = dog.confidence1.rounded(toPlaces: 1.0)
            dataEntry2.label = dog.identifier2
            dataEntry2.value = dog.confidence2.rounded(toPlaces: 1.0)
            dataEntry3.label = dog.identifier3
            dataEntry3.value = dog.confidence3.rounded(toPlaces: 1.0)
            dataEntry4.label = dog.identifier4
            dataEntry4.value = dog.confidence4.rounded(toPlaces: 1.0)
            dataEntry5.label = dog.identifier5
            dataEntry5.value = dog.confidence5.rounded(toPlaces: 1.0)
            
            
//            var resultSet: [String : Double] = [dataEntry2.label! : dataEntry2.value]
//            resultSet[dataEntry3.label!] = dataEntry3.value
//            resultSet[dataEntry4.label!] = dataEntry4.value
//            resultSet[dataEntry5.label!] = dataEntry5.value
            
            dataSet.append(dataEntry1)
            
            let dataPreSet = [dataEntry2, dataEntry3, dataEntry4, dataEntry5]
            var dataSetConfidence = dataEntry1.value
            
            for data in dataPreSet {
                if data.value > 10 {
                    dataSet.append(data)
                    dataSetConfidence += data.value
                }
            }
            
            otherDataEntry.label = "Other"
            otherDataEntry.value = 100 - dataSetConfidence
            dataSet.append(otherDataEntry)
            
            let pieChartDataSet = PieChartDataSet(entries: dataSet, label: "")
            let chartData = PieChartData(dataSet: pieChartDataSet)
            let chartColors = [UIColor(named: "CustomOrange"), UIColor(named: "CustomBlue"), UIColor(named: "CustomGreen"), UIColor(named: "CustomRed"), UIColor(named: "CustomGrey")]
            
            pieChartDataSet.colors = chartColors as! [NSUIColor]
//            graphView.entryLabelColor = .red
            chartData.setValueTextColor(.label)
            
            graphView.noDataTextColor = .label
            graphView.legend.textColor = .label
            graphView.data = chartData
            
            
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
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
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

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Double) -> Double {
        return (self * places * 1000).rounded() / 10
    }
}
