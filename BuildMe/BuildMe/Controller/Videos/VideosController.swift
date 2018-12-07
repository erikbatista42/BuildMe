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
import FirebaseDatabase

class VideosController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    // prolly delete this later
    let saveFileName = "/test.mp4"
    var fbURL: String = "https://firebasestorage.googleapis.com/v0/b/buildme-b0040.appspot.com/o/Carpentry%2FXbmpOPX45peRqC8FJ9xT.mp4?alt=media&token=ef4d4173-5145-486d-8de2-b6154bef451d"
    
    // Objects for CollectionView
    var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    let cellId = "cellId"
    
    static var currentCategory: String!
    
    var posts = [Post]()
    
    fileprivate func fetchPost() {
//        let ref
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = VideosController.currentCategory
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddVideoBarBtnItem))
        
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
        setupCollectionView()
        self.imagePicker.delegate = self
    }
    
    
    
    @objc func handleAddVideoBarBtnItem() {
        let activityViewController = UIAlertController()
        
        let recordButton = UIAlertAction(title: "Shoot a tutorial 📹", style: .default, handler: { (action) -> Void in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    
                    //if the camera is available, and if the rear camera is available, the let the image picker do this
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.mediaTypes = [kUTTypeMovie as String]
                    self.imagePicker.allowsEditing = true
                    self.imagePicker.delegate = self
                    
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
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = ["public.movie"]
            self.present(imagePickerController, animated: true, completion: nil)
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        activityViewController.addAction(recordButton)
        activityViewController.addAction(uploadFromLibraryButton)
        activityViewController.addAction(cancelButton)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)

        // Create path to store video in Firebase Storage
        let videoStorageRef = Storage.storage().reference().child("\(VideosController.currentCategory ?? "")/" + makeRandomString(length: 20) + ".mp4")
        
        // Create path to store video link
        let videoDatabaseRef = Database.database().reference().child("\(VideosController.currentCategory ?? "")").childByAutoId()
        
        // File located on library
        guard let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        
        // Upload the file to the created path
        videoStorageRef.putFile(from: videoUrl, metadata: nil, completion: { (metdata, error) in
            if let error = error {
                print("ERROR -> VideosController.didFinishPickingMediaWithInfo: \(error.localizedDescription)")
            } else {
                print("upload successful")
                
                videoStorageRef.downloadURL(completion: { (url, error) in
                    // if error happens
                    guard url != nil else {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    
                    // write to db
                    guard let downloadUrl = url else { return }
                    let valuesDB = ["video": "\(downloadUrl)"]
//                    let valuesDB = ["video": "\(downloadUrl)", "futureTextFeature": "stuff from video like title or something"]
                    videoDatabaseRef.updateChildValues(valuesDB) { (error, ref) in
                        if let error = error {
                            print("Something went wrong writing to the database....: \(error.localizedDescription)")
                        } else {
                            print("successfully wrote to database")
                        }
                    }
                })
                
                // Generate Thumbnail
                let asset: AVAsset = AVAsset(url: videoUrl)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true
                var time = asset.duration
                time.value = min(time.value, 3)
                
                do {
                    let thumbnailImage = try imageGenerator.copyCGImage(at: time , actualTime: nil)
                    let image = UIImage(cgImage: thumbnailImage)
                    guard let imageData = image.pngData() else { return }
                    
                    if image.pngData() != nil {
                        print("Image data: \(imageData)")
                    } else {
                        print("IMG DATA IS NIL")
                    }
                    
                    let thumbnailStorageRef = Storage.storage().reference().child("thumbnails/" + self.makeRandomString(length: 20) + ".png")
                    
                    thumbnailStorageRef.putData(imageData, metadata: nil, completion: { (thumbnailMeta, error) in
                        if let error = error {
                            print("An error has occured while uploading thumbnail to firebase: \(error.localizedDescription)")
                        } else {
                            print("Thumbnail created successful")
                        }
                    })
                } catch {
                    print("An error has occured while making the thumbnail")
                }
            }
        })
    }
    
    
    
}

