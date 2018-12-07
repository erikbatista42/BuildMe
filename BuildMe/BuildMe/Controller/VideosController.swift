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
import Firebase
import FirebaseStorage

class VideosController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
    var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    let cellId = "cellId"
    
    static var currentCategory: String!
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleAddVideoBtn() {
        let activityViewController = UIAlertController()
        
        let recordButton = UIAlertAction(title: "Shoot a tutorial 📹", style: .default, handler: { (action) -> Void in
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
        
        let uploadFromLibraryButton = UIAlertAction(title: "Upload from library 📲", style: .default, handler: { (action) -> Void in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.mediaTypes = ["public.movie"]
            self.present(imagePickerController, animated: true, completion: nil)
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        activityViewController.addAction(recordButton)
        activityViewController.addAction(uploadFromLibraryButton)
        activityViewController.addAction(cancelButton)
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddVideoBtn))

        self.navigationItem.title = VideosController.currentCategory
        self.imagePicker.delegate = self

        setupCollectionView()
    }
    
    func randomString(length: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrtstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let len = Int32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let random = arc4random_uniform(UInt32(len))
            var nextCharacter = letters.character(at: Int(random))
            randomString += NSString(characters: &nextCharacter, length: 1) as String
        }
        return randomString
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Upload selected video to firebase
        dismiss(animated: true, completion: nil)
        
        // Create reference to upload video to it's place on Firebase
        let ref = Storage.storage().reference().child("\(VideosController.currentCategory ?? "")/" + randomString(length: 20) + ".mp4")
        
        // File located on library
        guard let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        print("video URL: ", videoUrl)
        
        // upload the file to the path
        _ = ref.putFile(from: videoUrl, metadata: nil, completion: { (metdata, error) in
            if let error = error {
                print("ERROR -> VideosController.didFinishPickingMediaWithInfo: \(error.localizedDescription)")
            } else {
                print("upload successful")
                
//                // GenerateThumbnail
                let asset: AVAsset = AVAsset(url: videoUrl)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true
                var time = asset.duration
                time.value = min(time.value, 3)
//
                do {
                    let thumbnailImage = try imageGenerator.copyCGImage(at: time , actualTime: nil)
                    let image = UIImage(cgImage: thumbnailImage)
                    guard let imageData = image.pngData() else { return }

                    if image.pngData() != nil {
                        print("Image data: \(imageData)")
                    } else {
                        print("IMG DATA IS NIL")
                    }
//
                    let thumbnailStorageRef = Storage.storage().reference().child("thumbnails/" + self.randomString(length: 20) + ".png")
                
                    thumbnailStorageRef.putData(imageData, metadata: nil, completion: { (thumbnailMeta, error) in
                        if let error = error {
                            print("An error has occured while uploading thumbnail to firebase: \(error.localizedDescription)")
                        } else {
//                            let thumbnailUrl = thumbnailMeta.
                            print("Thumbnail created successful")
                        }
                    })
//            })
                } catch {
                    print("An error has occured while making the thumbnail")
                }
           }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("play video")
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        // Makes cell corners round
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
    
}
