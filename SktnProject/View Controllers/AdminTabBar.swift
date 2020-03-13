//
//  AdminTabBar.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-03-09.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit

class AdminTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let transperentBlackColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        transperentBlackColor.setFill()
        UIRectFill(rect)

        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            tabBar.backgroundImage = image
        }

        UIGraphicsEndImageContext()
        
    }

}
