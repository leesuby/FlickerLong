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

//    func getProfile(){
//        Repository.getProfileUser { result in
//            self.profileData = result
//        }
//    }
//
//    func getPublicPhoto(){
//        Repository.getPublicPhoto { result in
//            self.publicData = result
//        }
//    }
//
//    func getAlbumList(){
//        Repository.getAlbum { result in
//            self.albumList = result
//        }
//    }
//
//    func getDetailAlbum(albumId: String){
//        Repository.getDetailAlbum(albumId: albumId) { result in
//            self.publicData = result
//        }
//    }
}
