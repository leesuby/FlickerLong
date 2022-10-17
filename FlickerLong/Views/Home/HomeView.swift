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
    let activityIndicator = UIActivityIndicatorView()
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
        self.view = viewController.view
    }
    
    func initView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.DynamicLayout.spacing //as per your requirement
        layout.minimumInteritemSpacing = 0 //as per your requirement
        layout.scrollDirection = .vertical
        viewController.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView = viewController.collectionView
        
        activityIndicator.color = .darkGray
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
    }
    
    func initConstraint(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
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
