//
//  Post.swift
//  BuildMe
//
//  Created by luxury on 12/7/18.
//  Copyright © 2018 luxury. All rights reserved.
//

import Foundation

struct Post {
    var videoUrl: String
    
    init(videoUrl: String, dictionary: [String: Any]) {
        self.videoUrl = dictionary["videoUrl"] as? String ?? ""
    }
}
