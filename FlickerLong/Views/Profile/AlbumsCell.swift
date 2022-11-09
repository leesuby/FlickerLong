//
//  AlbumsCell.swift
//  FlickerLong
//
//  Created by LAP15335 on 24/10/2022.
//

import UIKit

protocol AlbumsCellDelegate{
    func albumClicked(albumModel : AlbumModel)
}

class AlbumsCell: UICollectionViewCell {
    var albumList : [AlbumModel] = []
    var albumCollectionView : UICollectionView!
    var delegate: AlbumsCellDelegate!
    
    var viewModel: ProfileViewModel!
    func bind(with vm: ProfileViewModel) {
        self.viewModel.bindtoView = {
            self.reloadDataCollectionView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        initConstraint()
    }
    
    func initView(){
        let layout = UICollectionViewFlowLayout()
        albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        albumCollectionView.backgroundColor = .clear
        
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: "albumCell")
        
        viewModel = ProfileViewModel()
        bind(with: viewModel)
        
    }

    func initConstraint(){
        addSubview(albumCollectionView)
        albumCollectionView.translatesAutoresizingMaskIntoConstraints = false
        albumCollectionView.topAnchor.constraint(equalTo: topAnchor,constant: Constant.padding).isActive = true
        albumCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        albumCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        albumCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func getData(){
        Repository.getAlbum { [self] result in
            self.viewModel.albumList = result
        }
    }
    func reloadDataCollectionView(){
        self.albumList = viewModel.albumList
        DispatchQueue.main.async {
            self.albumCollectionView.reloadData()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error create AlbumsCell")
    }
}

extension AlbumsCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as? AlbumCell{
            albumCell.config(album: albumList[indexPath.item])
            cell = albumCell
        }
        
        return cell
    }
    
    
    //Flowlayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 150)
    }
    
    //Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AlbumCell
        
        delegate.albumClicked(albumModel: cell.albumModel)
    }
}
