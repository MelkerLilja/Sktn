//
//  ViewController.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-02-26.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.addBackground()
        signUpButton.styleButton()
        loginButton.styleButton()
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        signUpButton.bounce()
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginButton.bounce()
    }
}


