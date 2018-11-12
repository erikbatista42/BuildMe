//
//  ViewController.swift
//  BuildMe
//
//  Created by luxury on 11/10/18.
//  Copyright © 2018 luxury. All rights reserved.
//

import UIKit

class MainController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    

    var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 6, bottom: 15, right: 6)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        collectionView?.showsVerticalScrollIndicator = false
        
        setupNavBar()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2.1) / 2.1
        return CGSize(width: width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        // Makes cell corners round
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    
    func setupNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.isTranslucent = false
        self.navigationItem.title = "BuildMe"
    }


}

