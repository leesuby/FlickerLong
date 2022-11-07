//
//  PhotoPickerViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 17/10/2022.
//

import UIKit
import Photos
class PhotoPickerViewController: UIViewController {

    private var photoPickerView : PhotoPickerView!
    private var listImages : [PHAsset] = []
    private var listChooseImage : [UIImage] = []
    var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Photo Library"
        
        photoPickerView = PhotoPickerView(viewController: self)
        photoPickerView.initView()
        photoPickerView.initConstraint()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PickerImageCell.self, forCellWithReuseIdentifier: "pickerCell")
        
        getImageFromLibrary()
        setUpNavigation()
    }
    
    func getImageFromLibrary(){
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        
        assets.enumerateObjects { object, _, _ in
            self.listImages.append(object)
        }
        
        collectionView.reloadData()
    }
    
    func setUpNavigation(){
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButton))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func nextButton(){
        let vc = PostViewController()
        vc.listImage = self.listChooseImage
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            self.tabBarController?.tabBar.isHidden = false
            self.tabBarController?.selectedIndex = Constant.UserSession.currentTab.rawValue
        }
    }
}

extension PhotoPickerViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PickerImageCell {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            listChooseImage.append(cell.imageView.image!)
            cell.chooseMode(isChoose: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PickerImageCell {
            listChooseImage.removeAll { image in
                image == cell.imageView.image
            }
            if(listChooseImage.isEmpty){
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
            cell.chooseMode(isChoose: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/4 - 3, height: collectionView.frame.size.width/4 - 3)
    }
}

extension PhotoPickerViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let pickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickerCell", for: indexPath) as? PickerImageCell{
            PHImageManager.default().requestImage(for: listImages[indexPath.item], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { image, _ in
                DispatchQueue.main.async {
                    pickerCell.config(image: image!)
                }
            }
            cell = pickerCell
           
        }
        return cell
    }
    
    
}
