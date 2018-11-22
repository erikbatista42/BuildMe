//
//  HomeControllerCollectionViewCell.swift
//  BuildMe
//
//  Created by luxury on 11/22/18.
//  Copyright © 2018 luxury. All rights reserved.
//

import Foundation
import UIKit

class HomeControllerCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .yellow
        
        // Makes cell corners round
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
