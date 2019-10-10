//
//  CollectionItemViewCell.swift
//  Friends List
//
//  Created by Nigell Dennis on 6/10/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import UIKit

class CollectionItemViewCell: UICollectionViewCell {
    
    @IBOutlet weak var notificationDot: UIViewX!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        self.isSelected = false
    }
    
    override var isHighlighted: Bool {
        didSet {
            icon.tintColor = isHighlighted ? UIColor(named: "Label Color") : UIColor(named: "icon tint")
        }
    }
    
    override var isSelected: Bool {
        didSet {
            notificationDot.isHidden = true
            icon.tintColor = isSelected ? UIColor(named: "Label Color") : UIColor(named: "icon tint")
        }
    }
}
