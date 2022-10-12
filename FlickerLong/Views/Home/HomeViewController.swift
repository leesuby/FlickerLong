//
//  HomeViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var homeView : HomeView!
    var collectionView : UICollectionView!
    private var controllerCollectionView : GeneCollectionView<PopularCell, String>!
    private var listImage : [String] = ["a","b"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView = HomeView(viewController: self)
        homeView.initView()
        homeView.initConstraint()
        
        controllerCollectionView = GeneCollectionView<PopularCell,String>(cellIdentifier: "popular", items: listImage)
        controllerCollectionView.configureSizeForItemAt { indexPath in
            return CGSize(width: 50, height: 50)
        }
        
        collectionView.delegate = controllerCollectionView
        collectionView.dataSource = controllerCollectionView
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: "popular")
    }
    

}
