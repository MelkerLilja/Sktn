//
//  Show.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-02-27.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String: Any])
}


struct Show {
    
    var image: String
    var title: String
    var date: String
    var description: String
    var timeStamp: Timestamp
    
    var dictionary: [String: Any]{
        return [
            "image": image,
            "title": title,
            "date": date,
            "description": description,
            "timeStamp": timeStamp
        ]
    }
}

extension Show : DocumentSerializable {
    init?(dictionary:[String: Any]) {
        guard let image = dictionary["image"] as? String,
            let title = dictionary["title"] as? String,
            let date = dictionary["date"] as? String,
            let description = dictionary ["description"] as? String,
            let timeStamp = dictionary ["timeStamp"] as? Timestamp else {return nil}
        
        self.init(image: image, title: title, date: date, description: description, timeStamp: timeStamp)
    }
}

