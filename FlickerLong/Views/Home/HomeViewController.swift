//
//  HomeViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import UIKit

class HomeViewController: UIViewController, View{
    typealias viewModel = HomeViewModel
    var viewModel: HomeViewModel!
    func bind(with vm: HomeViewModel) {
        self.viewModel.bindToView = {
            self.reloadDataCollectionView()
        }
    }
    
    private var homeView : HomeView!
    var collectionView : UICollectionView!
    private var datasourceCollectionView : GenericCollectionViewDataSource<PhotoView>!
    private var delegateCollectionView : GenericCollectionViewDelegate!
    
    private var widthView : CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = HomeViewModel()
        self.widthView = self.view.frame.size.width
        
        //Set VIEW
        homeView = HomeView(viewController: self)
        homeView.initView()
        homeView.initConstraint()
        
        //Set COLLECTIONVIEW
        datasourceCollectionView = GenericCollectionViewDataSource<PhotoView>(items: self.viewModel.listPicture)
        datasourceCollectionView.setConfigureCell { indexPath in
            
            var cell = UICollectionViewCell()
            if let popularCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "popular", for: indexPath) as? PopularCell{
                
                popularCell.config(photo: self.viewModel.listPicture[indexPath.row])
                cell = popularCell
            }
            return cell
        }
        
        delegateCollectionView = GenericCollectionViewDelegate()
        delegateCollectionView.setConfigureSizeForItemAt { [self] indexPath in
            let photoWidth = datasourceCollectionView.items[indexPath].scaleWidth
            if(photoWidth == widthView){
                return CGSize(width: datasourceCollectionView.items[indexPath].scaleWidth, height: CGFloat(Constant.DynamicLayout.heightDynamic))
            }
            else{
                return CGSize(width: datasourceCollectionView.items[indexPath].scaleWidth - Constant.DynamicLayout.spacing/2, height: CGFloat(Constant.DynamicLayout.heightDynamic))
            }
        }
        
        collectionView.delegate = delegateCollectionView
        collectionView.dataSource = datasourceCollectionView
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: "popular")
        
        //Bind VIEWMODEL
        bind(with: self.viewModel)
    }
    
    
    //Reload data when ViewModel changes
    func reloadDataCollectionView(){
        datasourceCollectionView.items = self.viewModel.listPicture
        datasourceCollectionView.items = calculateDynamicLayout(data: datasourceCollectionView.items)
        DispatchQueue.main.async { [self] in
            collectionView.reloadData()
        }
    }
    
    
    func calculateDynamicLayout(data : [PhotoView]) -> [PhotoView]{
        var data: [PhotoView] = data.map {$0}
        var result: [PhotoView] = []
        var tmpArray : [PhotoView] = []
        
        let widthView : CGFloat = self.widthView
        var i : Int = 0
        while(i < data.count){
            let photo = data[i]
            var ratio : CGFloat = 0
            var totalWidth : CGFloat = 0
            var totalWidthPrev : CGFloat = 0
            
            var j : Int = 0
            while(j < tmpArray.count){
                let tmpPhoto = tmpArray[j]
                ratio += CGFloat(tmpPhoto.width/tmpPhoto.height)
                
                let trueScaleWidth = Constant.DynamicLayout.heightDynamic * tmpPhoto.width / tmpPhoto.height
                if(j + 1 == tmpArray.count){
                    
                    tmpPhoto.scaleWidth = widthView - totalWidth
                    if(tmpPhoto.scaleWidth <= Constant.DynamicLayout.minimumWidth || (tmpPhoto.scaleWidth < trueScaleWidth / 1.5 && trueScaleWidth < widthView)){
                        tmpArray.removeLast()
                        tmpArray[tmpArray.count - 1].scaleWidth = widthView - totalWidthPrev
                    }
                }
                else{
                    tmpPhoto.scaleWidth = trueScaleWidth
                    totalWidthPrev = totalWidth
                    if(tmpPhoto.scaleWidth <= Constant.DynamicLayout.minimumWidth){
                        tmpPhoto.scaleWidth = Constant.DynamicLayout.minimumWidth
                        totalWidth = Constant.DynamicLayout.minimumWidth + totalWidth
                    }
                    else{
                        totalWidth = tmpPhoto.scaleWidth + totalWidth}
                }
                j+=1
                
            }
            
            let totalHeight : CGFloat = widthView / (ratio == 0 ? 1 : ratio);
            
            if(totalHeight <= CGFloat(Constant.DynamicLayout.heightDynamic)){
                data.removeFirst(tmpArray.count)
                result.append(contentsOf: tmpArray)
                tmpArray = []
                i = 0
                
            }
            else{
                tmpArray.append(photo)
                i+=1
            }
        }
        
        return result
    }
    
}
