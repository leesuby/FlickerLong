//
//  ProfileView.swift
//  FlickerLong
//
//  Created by LAP15335 on 19/10/2022.
//

import Foundation
import UIKit

class ProfileView : MenuViewDelegate{
    func scrollTo(item: Int) {
        viewController.scrollToItem(item: item)
    }
    
    private var viewController : ProfileViewController!
    private var view : UIView!
    private var profileCollectionView: UICollectionView!
    private var isInit : Bool = true
    
    init(viewController: ProfileViewController!) {
        self.viewController = viewController
        self.view = viewController.view
    }
    
    var coverView : UIView!
    var coverImage : UIImageView!
    var userView : UIView!
    var avatarView : UIView!
    var avatar : UIImageView!
    var userName : UILabel!
    var numberOfPhotos : UILabel!
    var settingButton : UIButton!
    var menuView: MenuView!
    
    func initView(){
        coverView = UIView()
        coverView.backgroundColor = .clear
        
        coverImage = UIImageView()
        coverImage.image = UIImage(named: "BackgroundProfile")
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
        
        userView = UIView()
        userView.backgroundColor = .clear
        
        avatarView = UIView()
        avatarView.backgroundColor = .clear
        avatarView.layer.cornerRadius = 35
        avatarView.layer.borderColor = UIColor.white80a.cgColor
        avatarView.layer.borderWidth = 0.5
        avatarView.clipsToBounds = true
        
        avatar = UIImageView()
        avatar.contentMode = .scaleAspectFill
        
        userName = UILabel()
        userName.font = Constant.Title.font
        userName.textColor = .white
        userName.textAlignment = .center

        numberOfPhotos = UILabel()
        numberOfPhotos.font = Constant.SubTitle.font
        numberOfPhotos.textColor = .white
        numberOfPhotos.textAlignment = .center
        
        settingButton = UIButton()
        settingButton.setImage(UIImage(named: "SettingSymbol")?.withRenderingMode(.alwaysTemplate), for: .normal)
        settingButton.tintColor = .white
        settingButton.backgroundColor = .clear
        
        menuView = MenuView()
        menuView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        viewController.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        profileCollectionView = viewController.collectionView
        profileCollectionView.backgroundColor = .clear
        profileCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func initConstraint(){
        view.addSubview(coverView)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        coverView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        
        coverView.addSubview(coverImage)
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        coverImage.topAnchor.constraint(equalTo: coverView.topAnchor).isActive = true
        coverImage.leadingAnchor.constraint(equalTo: coverView.leadingAnchor).isActive = true
        coverImage.trailingAnchor.constraint(equalTo: coverView.trailingAnchor).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: coverView.bottomAnchor).isActive = true
        
        
        coverView.addSubview(userView)
        userView.translatesAutoresizingMaskIntoConstraints = false
        userView.centerYAnchor.constraint(equalTo: coverView.centerYAnchor).isActive = true
        userView.centerXAnchor.constraint(equalTo: coverView.centerXAnchor).isActive = true
        userView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        userView.widthAnchor.constraint(equalTo: coverView.widthAnchor).isActive = true
        
        userView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.topAnchor.constraint(equalTo: userView.topAnchor).isActive = true
        avatarView.centerXAnchor.constraint(equalTo: userView.centerXAnchor).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        avatarView.addSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor).isActive = true
        avatar.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        userView.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: Constant.padding).isActive = true
        userName.widthAnchor.constraint(equalTo: userView.widthAnchor).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        userView.addSubview(numberOfPhotos)
        numberOfPhotos.translatesAutoresizingMaskIntoConstraints = false
        numberOfPhotos.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5).isActive = true
        numberOfPhotos.widthAnchor.constraint(equalTo: coverView.widthAnchor).isActive = true
        numberOfPhotos.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        coverView.addSubview(settingButton)
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -Constant.padding).isActive = true
        settingButton.topAnchor.constraint(equalTo: coverView.topAnchor, constant: Constant.padding * 2).isActive = true
        settingButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.topAnchor.constraint(equalTo: coverView.bottomAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        menuView.initMenu()
        
        view.addSubview(profileCollectionView)
        profileCollectionView.translatesAutoresizingMaskIntoConstraints = false
        profileCollectionView.topAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
        profileCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setData(urlImage: URL, userName: String, uploadedPhoto: Int){
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: "https://avatars.githubusercontent.com/u/163410?v=4")!)
          
            DispatchQueue.main.async {
                self.userName.isSkeletonLoading = false
                self.avatar.isSkeletonLoading = false
                self.numberOfPhotos.isSkeletonLoading = false
                self.avatar.image = UIImage(data: data!)
                self.userName.text = userName
                self.numberOfPhotos.text = "\(uploadedPhoto) photos uploaded"
                self.isInit = false
            }
        }
        
    }
    
    func layoutSubView(){
        if(isInit){
            avatar.layer.cornerRadius = avatar.frame.size.height / 2
            
            userName.isSkeletonLoading = true
            avatar.isSkeletonLoading = true
            numberOfPhotos.isSkeletonLoading = true
        }
    }
    
}
