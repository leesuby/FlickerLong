//
//  HomeView.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import Foundation
import UIKit

class HomeView {
    var viewController : HomeViewController
    var view : UIView
    var collectionView : UICollectionView!
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
        self.view = viewController.view
    }
    
    func initView(){
        viewController.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView = viewController.collectionView
        
    }
    func initConstraint(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}
