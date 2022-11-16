//
//  ModeCell.swift
//  FlickerLong
//
//  Created by LAP15335 on 24/10/2022.
//

import UIKit

enum ModePhotos: Int{
    case dynamic = 0
    case fit = 1
}

class ModeCell: UICollectionViewCell {
    static var identifier = "modeCell"
    private var imageView : CacheImage!
    
    override var isHighlighted: Bool{
        didSet{
            imageView.tintColor = isHighlighted ? .black : .lightGray
        }
    }
    
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? .black : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        initConstraint()
    }
    
    func initView(){
        imageView = CacheImage(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.tintColor = .lightGray
    }
    
    func initConstraint(){
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
    }
    
    func config(with mode: ModePhotos){
        switch(mode){
        case .dynamic:
            imageView.image = UIImage(named: "DynamicLayout")
        case .fit:
            imageView.image = UIImage(named: "UnsplashLayout")
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error creating ModeCell")
    }
}
