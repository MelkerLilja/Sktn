//
//  User.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-03-12.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import Foundation

protocol UserSerializable {
    init?(dictionary:[String: Any])
}

struct User {
    
    var firstname: String
    var lastname: String
    var type: String
    var uid: String
    
    var dictionary: [String: Any]{
        return [
            "firstname": firstname,
            "lastname": lastname,
            "type": type,
            "uid": uid
        ]
    }
}



extension User : UserSerializable {
    init?(dictionary:[String: Any]) {
        guard let firstname = dictionary["firstname"] as? String,
            let lastname = dictionary["lastname"] as? String,
            let type = dictionary["type"] as? String,
            let uid = dictionary ["uid"] as? String else {return nil}
        
        self.init(firstname: firstname, lastname: lastname, type: type, uid: uid)
    }
}

