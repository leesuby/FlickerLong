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
    private var widthView : CGFloat!
    var collectionView : UICollectionView!
    private var listPictures : [PhotoView] = []
    private var page: Int = 1
    private var sizeCollectionView : Int = 20
    private var flagPaging : Bool = false
    private var flagInit : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = HomeViewModel()
        self.widthView = self.view.frame.size.width
        
        //Set VIEW
        homeView = HomeView(viewController: self)
        homeView.initView()
        homeView.initConstraint()
        
        //Set COLLECTIONVIEW
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: "popular")
        
        //Bind VIEWMODEL
        bind(with: self.viewModel)
    }
    
    
    //Reload data when ViewModel changes
    func reloadDataCollectionView(){
        listPictures = self.viewModel.listPicture
        listPictures = calculateDynamicLayout(sliceArray: listPictures[..<sizeCollectionView])
        DispatchQueue.main.async { [self] in
            collectionView.reloadData()
            if(flagPaging == true)
            {
                flagPaging = false
            }
        }
    }
    
    //Function to calculate size for each cell in Dynamic Layout
    func calculateDynamicLayout(sliceArray : ArraySlice<PhotoView>) -> [PhotoView]{
        var data: [PhotoView] = Array(sliceArray)
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


// MARK: Setting for UICollectionView
extension HomeViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let popularCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "popular", for: indexPath) as? PopularCell{
            
            popularCell.config(photo: self.viewModel.listPicture[indexPath.row])
            cell = popularCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listPictures.count == 0{
            flagInit = false
        }
        return listPictures.count
    }
    
}

extension HomeViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photoWidth = listPictures[indexPath.item].scaleWidth
        if(photoWidth == widthView){
            return CGSize(width: photoWidth!, height: CGFloat(Constant.DynamicLayout.heightDynamic))
        }
        else{
            return CGSize(width: photoWidth! - Constant.DynamicLayout.spacing/2, height: CGFloat(Constant.DynamicLayout.heightDynamic))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.flagInit == false){
            let height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            if distanceFromBottom < height {
                if(self.flagPaging == false){
                    self.flagPaging = true
                    self.sizeCollectionView = ((self.sizeCollectionView + 20) >= 100) ? 100 : self.sizeCollectionView + 20
                    self.reloadDataCollectionView()
                }
            }
        }
    }
}
