//
//  ViewController.swift
//  BuildMe
//
//  Created by luxury on 11/10/18.
//  Copyright © 2018 luxury. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
        setupNavBar()
    }
    
    func setupNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.isTranslucent = false
        self.navigationItem.title = "BuildMe"
    }


}

