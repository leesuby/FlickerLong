//
//  HomeView.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import Foundation
import UIKit

class HomeView {
    init(vc : HomeViewController){
        initView(vc: vc)
        initConstraint(vc: vc)
    }
    
    func initView(vc : HomeViewController){
        vc.view.backgroundColor = .white
        
        vc.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        vc.collectionView.backgroundColor = .clear
        
        vc.modeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.modeCollectionView.backgroundColor = .clear
    }
    
    func initConstraint(vc : HomeViewController){
        let view: UIView = vc.view
        
        view.addSubview(vc.modeCollectionView)
        vc.modeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        vc.modeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        vc.modeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.modeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        vc.modeCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(vc.collectionView)
        vc.collectionView.translatesAutoresizingMaskIntoConstraints = false
        vc.collectionView.topAnchor.constraint(equalTo: vc.modeCollectionView.bottomAnchor).isActive = true
        vc.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vc.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        vc.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        
    }
}
