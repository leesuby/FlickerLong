//
//  ProfileViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 14/10/2022.
//

import UIKit

enum MenuOption : Int {
    case photos = 0
    case album = 1
}

class ProfileViewController: UIViewController, AlbumsCellDelegate {
    func albumClicked(albumModel: AlbumModel) {
     
        let vc = AlbumViewController()
        vc.albumModel = albumModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var viewModel : ProfileViewModel!
    func bind(with vm : ProfileViewModel){
        vm.bindtoView = {
            self.profileView.setData(urlImage: URL(string: vm.profileData.avatarURL)!, userName: vm.profileData.userName, uploadedPhoto: vm.profileData.photosUpload)
        }
    }
    
    private var profileView: ProfileView!
    var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel = ProfileViewModel()
        viewModel.getProfile()

        profileView = ProfileView(viewController: self)
        profileView.initView()
        profileView.initConstraint()
        
        bind(with: viewModel)
    
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: "photosCell")
        collectionView.register(AlbumsCell.self, forCellWithReuseIdentifier: "albumsCell")
        collectionView.isPagingEnabled = true
        
    }
    
    override func viewWillLayoutSubviews() {
        profileView.layoutSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Constant.UserSession.currentTab = .profile
        if(tabBarController?.tabBar.isHidden == true){
            tabBarController?.tabBar.isHidden = false
        }
    }

}

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let baseConstant : Int = (Int(view.frame.size.width) / 2 - Int(profileView.menuView.slider.frame.size.width)) / 2
        profileView.menuView.sliderLeftConstraint.constant = scrollView.contentOffset.x / 2 + CGFloat(baseConstant)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        profileView.menuView.collectionView.selectItem(at: IndexPath(item: Int((targetContentOffset.pointee.x / view.frame.size.width)), section: 0), animated: true, scrollPosition: .left)
    }
    
    func scrollToItem(item: Int){
        collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: true, scrollPosition: .left)
    }
}

extension ProfileViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        let menuOption = MenuOption(rawValue: indexPath.item)!
        switch menuOption{
        case .album:
            if let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumsCell", for: indexPath) as? AlbumsCell{
                albumCell.delegate = self
                cell = albumCell
            }
        case .photos:
            if let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as? PhotosCell{
                photoCell.config(color: indexPath.item == 0 ? .blue : .gray)
                cell = photoCell
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
}
