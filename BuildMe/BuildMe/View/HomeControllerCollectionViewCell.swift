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
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Medium", size: 28)
        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let numberOfVideosLabel: UILabel = {
        let label = UILabel()
        label.text = "# videos"
        label.font = UIFont(name: "Helvetica", size: 17)
        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray
        
        // Makes cell corners round
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        
//        addSubview(categoryLabel)
////        categoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
////        categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
////        categoryLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
////        categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
//        categoryLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        categoryLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//
//
//        addSubview(numberOfVideosLabel)
//        numberOfVideosLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        numberOfVideosLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 0).isActive = true
//        numberOfVideosLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
//        numberOfVideosLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60).isActive = true
//        numberOfVideosLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        numberOfVideosLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
//        let categoryInfo = UIStackView(arrangedSubviews: [categoryLabel,numberOfVideosLabel])
        
        let categoryInformationStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [categoryLabel,numberOfVideosLabel])
            categoryLabel.widthAnchor.constraint(equalToConstant: 100)
            categoryLabel.heightAnchor.constraint(equalToConstant: 200)
            stackView.axis = .vertical
            stackView.backgroundColor = .red
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        addSubview(categoryInformationStackView)
        categoryInformationStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        categoryInformationStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        categoryInformationStackView.heightAnchor.constraint(equalToConstant: 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
