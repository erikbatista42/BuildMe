//
//  HomeControllerCollectionViewCell.swift
//  BuildMe
//
//  Created by luxury on 11/22/18.
//  Copyright © 2018 luxury. All rights reserved.
//

import Foundation
import UIKit

class VideosControllerCollectionViewCell: UICollectionViewCell {
    
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray
        
        // Makes cell corners round
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        
        addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
