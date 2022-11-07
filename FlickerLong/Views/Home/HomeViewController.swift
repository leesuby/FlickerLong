//
//  HomeViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, View{
    private let NUMBER_IMAGES_PER_PAGE = 20
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
    private var selectedIndex : IndexPath?
    private var delegateNav : ZoomTransitioningDelgate = ZoomTransitioningDelgate()
    private var listPictures : [PhotoSizeInfo] = []
    private var listCorePicture : [PhotoCore] = []
    private var flagPaging : Bool = false
    private var flagInit : Bool = true
    private var pageImage : Int = 1
    let refreshControl = UIRefreshControl()
    
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
        getData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Update Status User
        Constant.UserSession.currentTab = .home
        
        tabBarController?.tabBar.backgroundColor = .white
        navigationController?.delegate = delegateNav
        
    }
    
    //Pull to refresh
    @objc func refresh(_ sender: AnyObject) {
        flagPaging = false
        flagInit = true
        pageImage = 1
        self.viewModel = HomeViewModel()
        bind(with: self.viewModel)
        getData()
       
    }
    
    //Reload data when ViewModel changes
    func reloadDataCollectionView(){
        DispatchQueue.global().async { [self] in
            listPictures = self.viewModel.listPicture
            listPictures = Helper.calculateDynamicLayout(sliceArray: listPictures[..<listPictures.count], width: widthView)

            listCorePicture = convertToCoreData()
            
            if(NetworkStatus.shared.isConnected){
                deleteData()
                saveData()
            }
            
            DispatchQueue.main.async { [self] in
                collectionView.reloadData()
                
                if(refreshControl.isRefreshing){
                    refreshControl.endRefreshing()
                }
                if(flagPaging == true)
                {
                    flagPaging = false
                }
            }
        }
    }
    
    func getData(){
        if(!NetworkStatus.shared.isConnected){
            fetchData()
        }
        else{
            Repository.getPopularDataUnsplash(page: pageImage) { result in
                self.viewModel.listPicture.append(contentsOf: result)
            }
        }
    }
    
    func convertToCoreData() -> [PhotoCore]{
        var tmpArray : [PhotoCore] = []
        for picture in listPictures{
            let photo = PhotoCore(context: CoreDatabase.context)
            
            photo.url = picture.url.string
            photo.scaleWidth = picture.scaleWidth
            photo.scaleHeight = picture.scaleWidth
            photo.field = "Popular"
            
            if(listPictures.count <= NUMBER_IMAGES_PER_PAGE){
                do {
                    photo.data = try Data(contentsOf: picture.url)}
                catch{
                    photo.data = Data()
                }}
            
            tmpArray.append(photo)
            
        }
        return tmpArray
    }
    
    
    func fetchData(){
        Repository.coreDataManipulation(operation: .fetch, PhotoCore.self) { data in
            self.listCorePicture = data as! [PhotoCore]
            self.collectionView.reloadData()
        }
    }
    
    func deleteData(){
        if(listPictures.count <= NUMBER_IMAGES_PER_PAGE){
            Repository.coreDataManipulation(operation: .delete, PhotoCore.self)
        }
       
    }
    
    func saveData(){
        if(listPictures.count <= NUMBER_IMAGES_PER_PAGE){
            Repository.coreDataManipulation(operation: .save, PhotoCore.self)
        }
    }
    
}

// MARK: Setting animation
extension HomeViewController : ZoomingViewController{
    func getImageView() -> UIImageView? {
        if let indexPath = selectedIndex {
            let cell = self.collectionView.cellForItem(at: indexPath) as! PopularCell
            return cell.imageView
        }
        return nil
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelgate) -> UIImageView? {
        if let indexPath = selectedIndex {
            let cell = self.collectionView.cellForItem(at: indexPath) as! PopularCell
            return cell.imageView
        }
        return nil
    }
}


// MARK: Setting for UICollectionView
extension HomeViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let popularCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "popular", for: indexPath) as? PopularCell{
            
            popularCell.config(photo: self.listCorePicture[indexPath.row])
            cell = popularCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listCorePicture.count == 0{
            homeView.startLoading()
        }
        else{
            homeView.stopLoading()
        }
        flagInit = false
        return listCorePicture.count
    }
    
}

extension HomeViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        let cell : PopularCell = collectionView.cellForItem(at: indexPath)! as! PopularCell
        let vc = PhotoViewController()
        vc.image = cell.imageView.image
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photoWidth = listCorePicture[indexPath.item].scaleWidth
        if(photoWidth == widthView){
            return CGSize(width: photoWidth, height: CGFloat(Constant.DynamicLayout.heightDynamic))
        }
        else{
            return CGSize(width: photoWidth - Constant.DynamicLayout.spacing/2, height: CGFloat(Constant.DynamicLayout.heightDynamic))
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
                    self.pageImage += 1
                    getData()
                }
            }
        }
    }
}


extension HomeViewController: PhotoDetailTransitionAnimatorDelegate {
    func transitionWillStart() {
        guard let lastSelected = self.selectedIndex else { return }
        self.collectionView.cellForItem(at: lastSelected)?.isHidden = true
    }

    func transitionDidEnd() {
        guard let lastSelected = self.selectedIndex else { return }
        self.collectionView.cellForItem(at: lastSelected)?.isHidden = false
    }

    func referenceImage() -> UIImage? {
        guard
            let lastSelected = self.selectedIndex,
            let cell = self.collectionView.cellForItem(at: lastSelected) as? PopularCell
        else {
            return nil
        }

        return cell.imageView.image
    }

    func imageFrame() -> CGRect? {
        guard
            let lastSelected = self.selectedIndex,
            let cell = self.collectionView.cellForItem(at: lastSelected)
        else {
            return nil
        }

        return self.collectionView.convert(cell.frame, to: self.view)
    }
}
