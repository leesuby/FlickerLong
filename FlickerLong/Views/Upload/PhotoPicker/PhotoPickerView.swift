//
//  PhotoPickerView.swift
//  FlickerLong
//
//  Created by LAP15335 on 17/10/2022.
//

import Foundation
import UIKit

class PhotoPickerView{
    private var viewController : PhotoPickerViewController!
    private var view : UIView!
    private var collectionView : UICollectionView!
    
    init(viewController: PhotoPickerViewController!) {
        self.viewController = viewController
        self.view = viewController.view
    }
    
    func initView(){
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.DynamicLayout.spacing
        layout.minimumInteritemSpacing = 0 
        layout.scrollDirection = .vertical
        viewController.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView = viewController.collectionView
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
    }
    
    func initConstraint(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
}
