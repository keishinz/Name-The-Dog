//
//  DogCell.swift
//  Name The Dog
//
//  Created by Keishin CHOU on 2019/12/10.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit

class DogCell: UICollectionViewCell {
    
    @IBOutlet var dogImage: UIImageView!
    @IBOutlet var dogName: UILabel!
    @IBOutlet var editModeBackground: UIView!
    @IBOutlet var checkImage: UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            editModeBackground.isHidden = !isHighlighted
            checkImage.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            editModeBackground.isHidden = !isSelected
            checkImage.isHidden = !isSelected
        }
    }
    
}
