//
//  Profile.swift
//  FlickerLong
//
//  Created by LAP15335 on 21/10/2022.
//

import Foundation

class ProfileModel {
    var avatarURL : String
    var userName : String
    var photosUpload : Int
    
    init(avatarURL: String, userName: String, photosUpload: Int) {
        self.avatarURL = avatarURL
        self.userName = userName
        self.photosUpload = photosUpload
    }
    
}
