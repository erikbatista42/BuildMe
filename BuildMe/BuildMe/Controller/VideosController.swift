//
//  VideosController.swift
//  BuildMe
//
//  Created by luxury on 11/14/18.
//  Copyright © 2018 luxury. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices

class VideosController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, getSelectedCategoryText, CanMakeNoise {
    var noise: String?
    
    func makeNoise() {
        print("moo")
        noise = "moo"
    }
    

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
    var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    let cellId = "cellId"
    
    static var navTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddVideoBtn))
//        print(VideosController.navTitle)
        self.navigationItem.title = VideosController.navTitle
        
//        makeNoise()
//        print(noise)
        setupCollectionView()
    }
    
    func getCategory(text: String) {
        print(123)
        print("Category selected: " + text)
    }
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleAddVideoBtn() {
        let activityViewController = UIAlertController()
        
        let contactCreaterButton = UIAlertAction(title: "Shoot a tutorial 📹", style: .default, handler: { (action) -> Void in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    
                    //if the camera is available, and if the rear camera is available, the let the image picker do this
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.mediaTypes = [kUTTypeMovie as String]
                    self.imagePicker.allowsEditing = true
                    self.imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    self.imagePicker.videoMaximumDuration = 60
                    self.imagePicker.videoQuality = .typeIFrame960x540
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    self.postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
                }
            } else {
                self.postAlert("Camera inaccessable", message: "Application cannot access the camera.")
            }
        })
        
        let shareApp = UIAlertAction(title: "Upload from library 📲", style: .default, handler: { (action) -> Void in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.mediaTypes = ["public.movie"]
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        activityViewController.addAction(contactCreaterButton)
        activityViewController.addAction(shareApp)
        activityViewController.addAction(cancelButton)
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(123)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("play video")
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
    
    let getSelectedCategoryTextDelegate: getSelectedCategoryText? = nil
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        // Makes cell corners round
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
//        print("this ",HomeController.categories[indexPath.row])
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
