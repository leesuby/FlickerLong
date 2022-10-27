//
//  AlbumViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 26/10/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    var albumModel : AlbumModel!
    
    var viewModel: ProfileViewModel!
    func bind(with vm: ProfileViewModel) {
        self.viewModel.bindtoView = {
            self.reloadDataCollectionView()
        }
    }
    
    var collectionView : UICollectionView!
    var albumView: AlbumView!
    var listPhoto : [PhotoView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        title = albumModel.title
        albumView = AlbumView(viewController: self)
        albumView.initView()
        albumView.initConstraint()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: "photoCell")
        
        
        viewModel = ProfileViewModel()
        viewModel.getDetailAlbum(albumId: self.albumModel.id)
        bind(with: viewModel)
        
        
    }
    
    func reloadDataCollectionView(){
        listPhoto = viewModel.publicData
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension AlbumViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    //Datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PopularCell{
            photoCell.config(photo: listPhoto[indexPath.item])
            cell = photoCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPhoto.count
    }
    
    //FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - 3, height: collectionView.frame.size.width / 2 - 3)
    }
    
}
