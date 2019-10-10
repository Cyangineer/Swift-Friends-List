//
//  UserModel.swift
//  Friends List
//
//  Created by Nigell Dennis on 6/11/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import UIKit

class UserModel {
    var uid = ""
    var username = ""
    var email = ""
    var profilePicUrl = ""
    var timeStamp = ""
    
    init(uid: String, username: String, email: String, profilePicUrl: String, timeStamp: String) {
        self.uid = uid
        self.username = username
        self.email = email
        self.profilePicUrl = profilePicUrl
        self.timeStamp = timeStamp
    }
}
