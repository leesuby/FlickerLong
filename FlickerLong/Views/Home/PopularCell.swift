//
//  PopularCell.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import UIKit


class PopularCell: UICollectionViewCell {
    var imageView : CacheImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        initConstraint()
    }
    
    func initView(){
        imageView = CacheImage(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    func initConstraint(){
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
    }
    
    func config(photo : PhotoSizeInfo){
        self.layoutIfNeeded()
        imageView.realBound = bounds
        self.imageView.loadImageWithUrl(photo.url)
    }
    
    func config(photo : PhotoCore){
        self.layoutIfNeeded()
        imageView.realBound = bounds
        if(NetworkStatus.shared.isConnected){
            self.imageView.loadImageWithUrl(URL(string: photo.url ?? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstock.adobe.com%2Fsearch%2Fimages%3Fk%3Dno%2520image%2520available&psig=AOvVaw16tb-Yt6x_GWOPMkx6ffZb&ust=1667373566401000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCKDm4Nq4jPsCFQAAAAAdAAAAABAE")!)}
        else{
            self.imageView.image = UIImage(data: photo.data ?? Data())
            }
    }
    
    func configSkeleton(){
        imageView.realBound = bounds
        imageView.isSkeletonLoading = true
    }
    
    override func prepareForReuse() {
        imageView.isSkeletonLoading = false
    
    }

    
    required init?(coder: NSCoder) {
        fatalError("Error creating Popular Cell")
    }
}
