//
//  HomeViewController.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-03-07.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.addBackground()
        aboutLabel.text = Constants.Texts.aboutSktn
    }
}
