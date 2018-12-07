//
//  UsefulMethods.swift
//  BuildMe
//
//  Created by luxury on 12/7/18.
//  Copyright © 2018 luxury. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Used for creating a unique filename
    func makeRandomString(length: Int) -> String {
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
    
    // Create alerts easier
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
