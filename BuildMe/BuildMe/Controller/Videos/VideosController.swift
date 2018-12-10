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
import AVKit

class VideosController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    // prolly delete this later
    let saveFileName = "/test.mp4"
    var fbURL: String = "https://firebasestorage.googleapis.com/v0/b/buildme-b0040.appspot.com/o/Carpentry%2FXbmpOPX45peRqC8FJ9xT.mp4?alt=media&token=ef4d4173-5145-486d-8de2-b6154bef451d"
    
    // Objects for CollectionView
    var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    let cellId = "cellId"
    
    static var currentCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = VideosController.currentCategory
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddVideoBarBtnItem))
        
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
        self.imagePicker.delegate = self
        setupCollectionView()
        fetchPosts()
    }
    

    var posts = [Post]()
//    var op: [String] = []
    var videoDownloadLinks = [String]()
//    var videoThumbnailLinks = [String]()
     func fetchPosts() {
        let ref = Database.database().reference().child("\(VideosController.currentCategory ?? "")/")
//        var tempo = [Post]()
//        ref.observe(.childAdded, with: { (snapshot) in
//
//            print(snapshot.value ?? "")
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            let video = Post(videoUrl: "videoUrl", dictionary: dictionary)
////            self.posts.append(video)
//            print("printing urls....: \(self.posts.count)")
//            self.posts.insert(video, at: 0)
//            tempo.insert(video, at: 0)
//            print("tempo: \(tempo)")
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        self.collectionView.reloadData()
//        print("postsss: \(tempo.count)")
        
        // GET FIREBASE VIDEOS
        
        ref.observe(.childAdded, with: { snapshot in
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            
            let videoDownloadURL = postDict["videoUrl"]!
//            let videoThumbnail = postDict["thumbnail"]!
            
            self.videoDownloadLinks.insert(videoDownloadURL as! String, at: 0)
//            self.videoThumbnailLinks.insert(videoThumbnail as! String, at: 0)
            print(self.videoDownloadLinks.count)
            self.collectionView.reloadData()
        })
        
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
        
        let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000)
        
        let videoDatabaseRef = Database.database().reference().child("\(VideosController.currentCategory ?? "")/\(timeStamp)")
        
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
                    let valuesDB = ["videoUrl": "\(downloadUrl)"]
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
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.3098039216, blue: 0.3882352941, alpha: 1)
        // Makes cell corners round
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
    
    // TODO: Play the right video functionality
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("thisss: \(posts)")
        let links = posts[indexPath.row]
        guard let url = NSURL(string: links.videoUrl) else { return }
        let player = AVPlayer(url: url as URL)
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
        return videoDownloadLinks.count
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
        
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // hides vertical scroll bar  - it shows (true) by default
        collectionView?.showsVerticalScrollIndicator = false
        
        //  Here, we add the collectionView as a subview to the superView. You can only have one superView. Check this out to get a better understanding of what this comment is trying to say: https://goo.gl/images/TQ4mti
        view.addSubview(collectionView)
    }
    
}

