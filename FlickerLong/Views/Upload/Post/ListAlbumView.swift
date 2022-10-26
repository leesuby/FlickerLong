//
//  ListAlbumView.swift
//  FlickerLong
//
//  Created by LAP15335 on 26/10/2022.
//

import UIKit

class ListAlbumView{
    var viewController : ListAlbumViewController
    var view : UIView
    var collectionView : UICollectionView!
    
    init(viewController: ListAlbumViewController) {
        self.viewController = viewController
        self.view = viewController.view
    }
    
    func initView(){
        viewController.title = "Select Album"
        viewController.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        self.collectionView = viewController.collectionView
    }
    
    func initConstraint(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
