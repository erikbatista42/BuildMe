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
//        label.backgroundColor = .green
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let numberOfVideosLabel: UILabel = {
        let label = UILabel()
        label.text = "3 videos"
        label.font = UIFont(name: "Helvetica", size: 17)
//        label.backgroundColor = .yellow
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "blurbg.png")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
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
        
        addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        blurView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        blurView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        blurView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        addSubview(categoryInformationStackView)
        categoryInformationStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        categoryInformationStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        categoryInformationStackView.heightAnchor.constraint(equalToConstant: 200)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
