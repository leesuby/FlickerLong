//
//  HomeView.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import Foundation
import UIKit

class HomeView {
    let activityIndicator = UIActivityIndicatorView()
    
    init(vc : HomeViewController){
        initView(vc: vc)
        initConstraint(vc: vc)
    }
    
    func initView(vc : HomeViewController){
        vc.view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.DynamicLayout.spacing
        layout.minimumInteritemSpacing = 0 
        layout.scrollDirection = .vertical
        vc.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.collectionView.backgroundColor = .clear
        
        activityIndicator.color = .darkGray
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
    }
    
    func initConstraint(vc : HomeViewController){
        let view: UIView = vc.view
        view.addSubview(vc.collectionView)
        vc.collectionView.translatesAutoresizingMaskIntoConstraints = false
        vc.collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vc.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        vc.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func startLoading(){
        activityIndicator.startAnimating()
    }
    
    func stopLoading(){
        activityIndicator.stopAnimating()
    }
    
}
