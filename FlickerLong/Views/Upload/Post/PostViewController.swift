//
//  PostViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 19/10/2022.
//

import UIKit
import objectiveflickr

class PostViewController: UIViewController, ListAlbumViewControllerDelegate, OFFlickrAPIRequestDelegate {
    var choosenAlbum : AlbumModel? = nil
    var listImage : [UIImage]!
    var collectionView : UICollectionView!
    var postView : PostView!
    var repo : Repository = Repository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "New Post"
        
        postView = PostView(viewController: self)
        postView.initView()
        postView.initConstraint()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PickerImageCell.self, forCellWithReuseIdentifier: "photoCell")
        // set the delegate, here we assume it's the controller that's creating the request object
        
        
        setUpNavigation()
    }
    
    func setUpNavigation(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postButton))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func postButton(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let title : String = (self.postView.title.text == "" ? "No Title" : self.postView.title.text)!
        let description : String = (self.postView.description.text == "" ? "No Description" : self.postView.description.text)!
        
        repo.uploadImage(listImage: listImage, title: title, description: description)
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
            self.tabBarController?.selectedIndex = 2
        }
        
    }
    
    
    @objc func albumDidTapped(){
        let vc = ListAlbumViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func returnChosenAlbum(album: AlbumModel) {
        postView.chooseAlbum(title: album.title)
        self.choosenAlbum = album
        repo.albumId = album.id
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
    }
}

extension PostViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count > 4 ? 4 : listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PickerImageCell{
            
            photoCell.config(image: listImage[indexPath.item])
            if(indexPath.item == 3 && listImage.count > 4){
                photoCell.showMoreImage(number: listImage.count - 3)
            }
            cell = photoCell
        }
        
        return cell
    }
    
    
}

extension PostViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 4 - 6, height: collectionView.frame.size.width / 4 - 6)
    }
}
