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

    
    // We declare collectionView as a global variable here because we mess around with the collection view in different functions
    var collectionView: UICollectionView!
    
    let flowLayout = UICollectionViewFlowLayout()
    let cellId = "cellId"
    
    let categories = ["Craft", "Origami", "Food", "Carpentry", "Mechanics", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        setupCollectionView()
        setupNavigationController()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoController = VideosController()
        self.navigationController?.pushViewController(videoController, animated: true)
        VideosController.currentCategory = categories[indexPath.row]
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
        
        cell.backgroundImage.image = UIImage(named: "\(categories[indexPath.row]).jpg")
        
        let ref = Database.database().reference().child("\(categories[indexPath.row])/")
        
        ref.observe(.value, with: { (snapshot) in
            
            let numOfChildrens = snapshot.childrenCount
//            print("\(self.categories[indexPath.row]): \(numOfChildrens)")
            cell.numberOfVideosLabel.text = "\(numOfChildrens) videos"
        }) { (error) in
            print("failed to fetch num of posts: ",error.localizedDescription)
        }
        return cell
    }
    
   
    
    func setupCollectionView() {
        let navBarSize = navigationController?.navigationBar.frame.height
        let calculateHeightOfCollectionView = view.bounds.height - navBarSize! - 12.5
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: calculateHeightOfCollectionView)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        
        // Use this property to extend the space between your content and the edges of the content view.
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 6, bottom: 15, right: 6)
        
        collectionView.register(HomeControllerCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        // Delegate - behavior (What happens when it is tapped, when double tapped, if you hold it etc..
        // DataSource - customization (color, height, width, rounded corners etc..
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView?.showsVerticalScrollIndicator = false
        
        view.addSubview(collectionView)
    }
    
    func setupNavigationController() {
        let navBar = navigationController?.navigationBar
        navBar?.isTranslucent = false
        navBar?.barTintColor = #colorLiteral(red: 0.9813231826, green: 0.9813460708, blue: 0.9813337922, alpha: 1)
        navBar?.tintColor = #colorLiteral(red: 0.2823529412, green: 0.2980392157, blue: 0.368627451, alpha: 1)
        let logo = UIImage(named: "BUILDME.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }


}

