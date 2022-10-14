//
//  PopularCell.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import UIKit

class PopularCell: UICollectionViewCell {
    private var imageView : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        initConstraint()
    }
    
    func initView(){
        imageView = UIImageView(frame: .zero)
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
    
    func config(photo : PhotoView){
        imageView.image = photo.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error creating Popular Cell")
    }
}
