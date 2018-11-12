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
    let flowLayout = UICollectionViewLayout()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView.register
        setupNavBar()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
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

