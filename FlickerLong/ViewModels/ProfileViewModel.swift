//
//  ProfileViewModel.swift
//  FlickerLong
//
//  Created by LAP15335 on 20/10/2022.
//

import Foundation

class ProfileViewModel : ViewModel {
    typealias Item = Profile
    var model: Profile?
    
    var profileData : ProfileModel! {
        didSet{
            self.bindtoView()
        }
    }
    var publicData : [PhotoSizeInfo]!{
        didSet{
            self.bindtoView()
        }
    }
    var albumList : [AlbumModel]!{
        didSet{
            self.bindtoView()
        }
    }
    
    var bindtoView: (() -> ()) = {}


}
