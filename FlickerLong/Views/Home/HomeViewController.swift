//
//  HomeViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    private var homeView : HomeView!
    var collectionView : UICollectionView!
    private var datasourceCollectionView : GenericCollectionViewDataSource<String>!
    private var delegateCollectionView : GenericCollectionViewDelegate!
    private var listImage : [String] = ["a","b"]
    
//    var datasource: DataSource = HomeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView = HomeView(viewController: self)
        homeView.initView()
        homeView.initConstraint()
        
        datasourceCollectionView = GenericCollectionViewDataSource<String>(items: listImage)
        datasourceCollectionView.setConfigureCell { indexPath in
            var cell = UICollectionViewCell()
            if let popularCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "popular", for: indexPath) as? PopularCell{
                cell = popularCell
            }
            return cell
        }
        
        delegateCollectionView = GenericCollectionViewDelegate()
        delegateCollectionView.setConfigureSizeForItemAt { indexPath in
            return CGSize(width: 50, height: 50)
        }
        
        collectionView.delegate = delegateCollectionView
        collectionView.dataSource = datasourceCollectionView
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: "popular")
    }
    

}


protocol ViewModel {
    var model: Model? { get set }
}

protocol Model {
    
}

protocol CellWithViewModel {
    var viewModel: ViewModel? { get set }
    
    func bind(with vm: ViewModel)
}
