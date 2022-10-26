//
//  AlbumView.swift
//  FlickerLong
//
//  Created by LAP15335 on 26/10/2022.
//

import Foundation
import UIKit

class AlbumView{
    var viewController : AlbumViewController
    var view: UIView
    var collectionView : UICollectionView!
    
    init(viewController: AlbumViewController) {
        self.viewController = viewController
        self.view = viewController.view
    }
    
    func initView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        viewController.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView = viewController.collectionView
    }
    
    func initConstraint(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
