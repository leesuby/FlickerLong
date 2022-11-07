//
//  PhotosCell.swift
//  FlickerLong
//
//  Created by LAP15335 on 24/10/2022.
//

import UIKit

class PhotosCell: UICollectionViewCell, ModeCollectionViewDelegate {
    func changeMode(mode: ModePhotos) {
        switch(mode){
        case .dynamic:
            photosController.modePhotos = .dynamic
        case .fit:
            photosController.modePhotos = .fit
        }
        self.photosCollectionView.reloadData()
    }
    
    var viewModel: ProfileViewModel!
    func bind(with vm: ProfileViewModel) {
        self.viewModel.bindtoView = {
            self.reloadDataCollectionView()
        }
    }
    
    private var modeCollectionView : UICollectionView!
    private var modeController : ModeCollectionView!
    private var photosCollectionView : UICollectionView!
    private var photosController : PhotoCollectionView!
    private var photosLayout : UICollectionViewFlowLayout!
    private var listPictures : [PhotoSizeInfo] = []
    private var widthView : CGFloat!
    let activityIndicator = UIActivityIndicatorView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        initConstraint()
        
        widthView = frame.size.width
        viewModel = ProfileViewModel()
        getData()
        bind(with: viewModel)
        
    }
    
    func initView(){
        modeController = ModeCollectionView()
        modeController.delegate = self
        let modeLayout = UICollectionViewFlowLayout()
        modeLayout.scrollDirection = .horizontal
        modeLayout.minimumLineSpacing = 10
        modeLayout.minimumInteritemSpacing = 10
        modeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: modeLayout)
        modeCollectionView.backgroundColor = .white
        modeCollectionView.delegate = modeController
        modeCollectionView.dataSource = modeController
        modeCollectionView.register(ModeCell.self, forCellWithReuseIdentifier: "modeCell")
        modeCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        
        photosController = PhotoCollectionView()
        photosController.modePhotos = .dynamic
        photosController.indicator = activityIndicator
        photosLayout = UICollectionViewFlowLayout()
        photosLayout.scrollDirection = .vertical
        photosLayout.minimumLineSpacing = 6
        photosLayout.minimumInteritemSpacing = 0
        photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: photosLayout)
        photosCollectionView.backgroundColor = .white
        photosCollectionView.delegate = photosController
        photosCollectionView.dataSource = photosController
        photosCollectionView.register(PopularCell.self, forCellWithReuseIdentifier: "photosCell")
        
        activityIndicator.color = .darkGray
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
    }
    
    func initConstraint(){
        addSubview(modeCollectionView)
        modeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        modeCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        modeCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        modeCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        modeCollectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(photosCollectionView)
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photosCollectionView.topAnchor.constraint(equalTo: modeCollectionView.bottomAnchor).isActive = true
        photosCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        photosCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        photosCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        photosCollectionView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.topAnchor.constraint(equalTo: photosCollectionView.topAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: photosCollectionView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: photosCollectionView.centerYAnchor).isActive = true
    }
    
    func getData(){
        Repository.getPublicPhoto { result in
            self.viewModel.publicData = result
        }
        
    }
    
    func config(color: UIColor){
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error create photosCell")
    }
    
    //Reload data when ViewModel changes
    func reloadDataCollectionView(){
        photosController.datasource = self.viewModel.publicData
        photosController.datasource = Helper.calculateDynamicLayout(sliceArray: photosController.datasource[..<photosController.datasource.count],width: widthView)
        DispatchQueue.main.async { [self] in
            photosCollectionView.reloadData()
        }
    }
}

protocol ModeCollectionViewDelegate{
    func changeMode(mode : ModePhotos)
}

class ModeCollectionView : NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var delegate : ModeCollectionViewDelegate!
    
    //DATA SOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let modeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "modeCell", for: indexPath) as? ModeCell {
            if(indexPath.item == 0) {modeCell.config(with: .dynamic)}
            else{modeCell.config(with: .fit)}
            cell = modeCell
        }
        return cell
    }
    
    //FLOW LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mode : ModePhotos = ModePhotos(rawValue: indexPath.item)!
        delegate.changeMode(mode: mode)
    }
    
}

class PhotoCollectionView : NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var datasource : [PhotoSizeInfo] = []
    var modePhotos : ModePhotos!
    var indicator : UIActivityIndicatorView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if datasource.count == 0{
            indicator.startAnimating()
        }
        else{
            indicator.stopAnimating()
        }
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let photosCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as? PopularCell {
            photosCell.config(photo: datasource[indexPath.row])
            cell = photosCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch(modePhotos){
        case .dynamic:
            let photoWidth = datasource[indexPath.item].scaleWidth
            if(photoWidth == collectionView.frame.size.width){
                return CGSize(width: photoWidth!, height: CGFloat(Constant.DynamicLayout.heightDynamic))
            }
            else{
                return CGSize(width: photoWidth! - Constant.DynamicLayout.spacing/2, height: CGFloat(Constant.DynamicLayout.heightDynamic))
            }
        case .fit:
            return CGSize(width: collectionView.frame.size.width, height: CGFloat(Constant.DynamicLayout.heightDynamic))
        case .none:
            return .zero
        }
        
    }
    
}
