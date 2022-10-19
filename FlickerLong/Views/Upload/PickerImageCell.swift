//
//  PickerImageCell.swift
//  FlickerLong
//
//  Created by LAP15335 on 17/10/2022.
//

import UIKit

class PickerImageCell: UICollectionViewCell {
    
    var imageView : UIImageView!
    
    private var chooseView : UIView!
    private var chooseField : UIView!
    var checkSymbol : UIImageView!
    var numberOfImage : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        initConstraint()
    }
    
    func initView(){
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        chooseView = UIView()
        chooseView.backgroundColor = .black.withAlphaComponent(0.5)
        
        chooseField = UIView()
        chooseField.backgroundColor = .systemBlue
        chooseField.layer.cornerRadius = 14
        
        checkSymbol = UIImageView()
        checkSymbol.contentMode = .scaleAspectFit
        checkSymbol.image = UIImage(named: "CheckSymbol")
        
        numberOfImage = UILabel()
        numberOfImage.textColor = .white80a
        numberOfImage.font = .NunitoBold(size: 24)
        numberOfImage.textAlignment = .center
    }
    
    func initConstraint(){
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(chooseView)
        chooseView.translatesAutoresizingMaskIntoConstraints = false
        chooseView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        chooseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        chooseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        chooseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        chooseView.addSubview(chooseField)
        chooseField.translatesAutoresizingMaskIntoConstraints = false
        chooseField.topAnchor.constraint(equalTo: chooseView.topAnchor, constant: 4).isActive = true
        chooseField.trailingAnchor.constraint(equalTo: chooseView.trailingAnchor, constant: -4).isActive = true
        chooseField.widthAnchor.constraint(equalToConstant: 28).isActive = true
        chooseField.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        chooseField.addSubview(checkSymbol)
        checkSymbol.translatesAutoresizingMaskIntoConstraints = false
        checkSymbol.centerYAnchor.constraint(equalTo: chooseField.centerYAnchor).isActive = true
        checkSymbol.centerXAnchor.constraint(equalTo: chooseField.centerXAnchor).isActive = true
        checkSymbol.widthAnchor.constraint(equalToConstant: 28).isActive = true
        checkSymbol.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        chooseView.addSubview(numberOfImage)
        numberOfImage.translatesAutoresizingMaskIntoConstraints = false
        numberOfImage.centerYAnchor.constraint(equalTo: chooseView.centerYAnchor).isActive = true
        numberOfImage.widthAnchor.constraint(equalTo: chooseView.widthAnchor).isActive = true
        numberOfImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func config(image : UIImage){
        self.imageView.image = image
        self.chooseView.isHidden = true
    }
    
    func chooseMode(isChoose : Bool){
        if(isChoose){
            self.chooseView.isHidden = false
        }
        else{
            self.chooseView.isHidden = true
        }
        
    }
    
    func showMoreImage(number: Int){
        self.chooseView.isHidden = false
        self.chooseField.isHidden = true
        self.numberOfImage.text = "+\(number)"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Error while creating pickimageCell")
    }
}
