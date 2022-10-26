//
//  ListAlbumViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 26/10/2022.
//

import UIKit

protocol ListAlbumViewControllerDelegate{
    func returnChosenAlbum(album: AlbumModel)
}

class ListAlbumViewController: UIViewController, AlbumsCellDelegate {
    func albumClicked(albumModel: AlbumModel) {
        delegate.returnChosenAlbum(album: albumModel)
        navigationController?.popViewController(animated: true)
    }
    
    var collectionView : UICollectionView!
    var listAlbumView : ListAlbumView!
    var delegate : ListAlbumViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listAlbumView = ListAlbumView(viewController: self)
        listAlbumView.initView()
        listAlbumView.initConstraint()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AlbumsCell.self, forCellWithReuseIdentifier: "albumsCell")
   
    }
}

extension ListAlbumViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //DataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumsCell", for: indexPath) as? AlbumsCell{
            albumCell.delegate = self
            cell = albumCell
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    //FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}
