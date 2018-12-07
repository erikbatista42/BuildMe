//
//  VideosControllerCollectionView.swift
//  BuildMe
//
//  Created by luxury on 12/7/18.
//  Copyright © 2018 luxury. All rights reserved.
//
import UIKit
import Foundation
import AVKit

// Make VideosController collectionView
extension VideosController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        // Makes cell corners round
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
    
    // TODO: Play video functionality
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/buildme-b0040.appspot.com/o/Carpentry%2FXbmpOPX45peRqC8FJ9xT.mp4?alt=media&token=ef4d4173-5145-486d-8de2-b6154bef451d")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2.1) / 2.1
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func setupCollectionView() {
        let navBarSize = navigationController?.navigationBar.frame.height
        let calculateHeightOfCollectionView = view.bounds.height - navBarSize! - 12.5
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: calculateHeightOfCollectionView)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        
        // Use this property to extend the space between your content and the edges of the content view.
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 6, bottom: 15, right: 6)
        
        // method to tell the collection view how to create a new cell of the given type
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
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
    
}
