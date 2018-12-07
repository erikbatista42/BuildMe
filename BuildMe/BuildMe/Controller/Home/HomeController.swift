//
//  ViewController.swift
//  BuildMe
//
//  Created by luxury on 11/10/18.
//  Copyright © 2018 luxury. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    /*
     What is UICollectionViewDelegateFlowLayout?
         The methods of this protocol define the:
         - size of items & spacing between items in the grid
     
     What is UICollectionViewDataSource?
        • Is responsible for providing the data and views required by a collection view.
        • A data source object represents your app’s data model and vends information to the collection view as needed.
    */
    
    // We declare collectionView as a global variable here because we might mess around with the collection view in different functions
    var collectionView: UICollectionView!
    
    let flowLayout = UICollectionViewFlowLayout()
    let cellId = "cellId"
    
    let categories = ["Craft", "Origami", "Food", "Carpentry", "Mechanics", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        /* We break them into function to:
        - Avoid polluting viewDidLoad
        - making the code more organizable
         */
        setupCollectionView()
        setupNavigationController()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoController = VideosController()
        self.navigationController?.pushViewController(videoController, animated: true)
        VideosController.navTitle = categories[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeControllerCollectionViewCell
        cell.categoryLabel.text = categories[indexPath.row]
        return cell
    }
    
    func setupCollectionView() {
        let navBarSize = navigationController?.navigationBar.frame.height
        let calculateHeightOfCollectionView = view.bounds.height - navBarSize! - 12.5
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: calculateHeightOfCollectionView)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        
        // Use this property to extend the space between your content and the edges of the content view.
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 6, bottom: 15, right: 6)
        
        // method to tell the collection view how to create a new cell of the given type
        
        collectionView.register(HomeControllerCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        // The delegate is the behavior of a cell (What happens when it is tapped, when double tapped, if you hold it etc..
        collectionView.delegate = self
        
        // The dataSource is the customization of a cell (color, height, width, rounded corners etc..
        collectionView.dataSource = self
        
        collectionView.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        // hides vertical scroll bar  - it shows (true) by default
        collectionView?.showsVerticalScrollIndicator = false
        
        //  Here, we add the collectionView as a subview to the superView. You can only have one superView. Check this out to get a better understanding of what this comment is trying to say: https://goo.gl/images/TQ4mti
        view.addSubview(collectionView)
    }
    
    func setupNavigationController() {
        let navBar = navigationController?.navigationBar
        navBar?.isTranslucent = false
        self.navigationItem.title = "BuildMe"
    }


}

