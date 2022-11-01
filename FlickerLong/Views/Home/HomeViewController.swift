//
//  HomeViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import UIKit
import CoreData

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
    private var listCorePicture : [PhotoCore] = []
    private var flagPaging : Bool = false
    private var flagInit : Bool = true
    private var pageImage : Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = HomeViewModel(pageImage: pageImage)
        self.widthView = self.view.frame.size.width
        
        //Set VIEW
        homeView = HomeView(viewController: self)
        homeView.initView()
        homeView.initConstraint()
        
        //Set COLLECTIONVIEW
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: "popular")
        
        if(NetworkStatus.shared.isConnected){
            
            //Bind VIEWMODEL
            bind(with: self.viewModel)}
        else{
            print("asdasdsad")
            fetchData()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Update Status User
        Constant.UserSession.currentTab = .home
        
        tabBarController?.tabBar.backgroundColor = .white
    }
    
    
    //Reload data when ViewModel changes
    func reloadDataCollectionView(){
        DispatchQueue.global().async { [self] in
            listPictures = self.viewModel.listPicture
            listPictures = Helper.calculateDynamicLayout(sliceArray: listPictures[..<listPictures.count], width: widthView)
            
            listCorePicture = convertToCoreData()
            
            
            DispatchQueue.main.async { [self] in
                collectionView.reloadData()
                if(flagPaging == true)
                {
                    flagPaging = false
                }
            }
        }
    }
    func convertToCoreData() -> [PhotoCore]{
        if( listPictures.count <= 20){
            deleteData()}
        var tmpArray : [PhotoCore] = []
        for picture in listPictures{
            let photo = PhotoCore(context: CoreDatabase.context)
            
            photo.url = picture.url.string
            photo.scaleWidth = picture.scaleWidth
            photo.scaleHeight = picture.scaleWidth
            photo.field = "Popular"
            
            if( listPictures.count <= 20){
                do {
                    photo.data = try Data(contentsOf: picture.url)}
                catch{
                    photo.data = Data()
                }}
            
            tmpArray.append(photo)
            
        }
        if( listPictures.count <= 20){
            do{
                try CoreDatabase.context.save()}
            catch{
                print("Can't save")
            }}
        return tmpArray
        
    }
    
    
    func fetchData(){
        let fetchRequest : NSFetchRequest<PhotoCore> = PhotoCore.fetchRequest()
        
        do {
            let result = try CoreDatabase.context.fetch(fetchRequest)
            listCorePicture = result
            print(listCorePicture.count)
            self.collectionView.reloadData()
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func deleteData(){
        let fetchRequest : NSFetchRequest<PhotoCore> = PhotoCore.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<any NSFetchRequestResult>)
        
        do {
            try CoreDatabase.persistentStoreCoordinator.execute(deleteRequest, with: CoreDatabase.context)
        } catch _ as NSError {
            // TODO: handle the error
        }
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
                    self.viewModel.getRecentImage(page: self.pageImage)
                }
            }
        }
    }
}
