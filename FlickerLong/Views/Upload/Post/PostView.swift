//
//  PostView.swift
//  FlickerLong
//
//  Created by LAP15335 on 19/10/2022.
//

import Foundation
import UIKit

class PostView{
    private var viewController : PostViewController!
    private var view : UIView!
    private var collectionView : UICollectionView!
    private var title: LimitedCharacterTextField!
    private var description: LimitedCharacterTextField!
    
    private var albumView : UIView!
    private var albumIcon : UIImageView!
    private var albumLabel: UILabel!
    private var albumButton: UIImageView!

    private var privacyView: UIView!
    private var privacyIcon: UIImageView!
    private var privacyLabel : UILabel!
    
    init(viewController: PostViewController){
        self.viewController = viewController
        self.view = viewController.view
    }
    
    func initView(){
        self.view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constant.DynamicLayout.spacing
        layout.minimumInteritemSpacing = 0
        
        viewController.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = viewController.collectionView
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        
        title = LimitedCharacterTextField()
        title.placeholder = "Title..."
        title.font = Constant.TextBox.font
        title.textColor = Constant.TextBox.color
        title.layer.borderColor = UIColor.darkGray.cgColor
        title.layer.borderWidth = 0.5
        
        description = LimitedCharacterTextField()
        description.placeholder = "Description..."
        description.font = Constant.TextBox.font
        description.textColor = Constant.TextBox.color
        description.layer.borderColor = UIColor.darkGray.cgColor
        description.layer.borderWidth = 0.5
        
        albumView = UIView()
        albumView.backgroundColor = .clear
        albumView.layer.borderColor = UIColor.darkGray.cgColor
        albumView.layer.borderWidth = 0.5
        albumIcon = UIImageView()
        albumIcon.image = UIImage(named: "AlbumSymbol")?.withRenderingMode(.alwaysTemplate)
        albumIcon.backgroundColor = .clear
        albumIcon.tintColor = .gray
        albumIcon.contentMode = .scaleAspectFit
        albumLabel = UILabel()
        albumLabel.text = "Albums"
        albumLabel.textColor = Constant.TextBox.color
        albumLabel.font = Constant.TextBox.font
        albumButton = UIImageView()
        albumButton.image = UIImage(named: "ForwardSymbol")
        albumButton.backgroundColor = .clear
        albumButton.contentMode = .scaleAspectFit
        
        privacyView = UIView()
        privacyView.backgroundColor = .clear
        privacyView.layer.borderColor = UIColor.darkGray.cgColor
        privacyView.layer.borderWidth = 0.5
        privacyIcon = UIImageView()
        privacyIcon.image = UIImage(named: "PrivacySymbol")
        privacyIcon.backgroundColor = .clear
        privacyIcon.contentMode = .scaleAspectFit
        privacyLabel = UILabel()
        privacyLabel.text = "Public"
        privacyLabel.textColor = .black
        privacyLabel.font = Constant.TextBox.font
    }
    
    func initConstraint(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.padding).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.padding).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.padding).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.size.width/4).isActive = true
        
        
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Constant.padding).isActive = true
        title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.padding).isActive = true
        title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.padding).isActive = true
        title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        view.addSubview(description)
        description.translatesAutoresizingMaskIntoConstraints = false
        description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Constant.padding).isActive = true
        description.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.padding).isActive = true
        description.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.padding).isActive = true
        description.heightAnchor.constraint(equalToConstant: 50).isActive = true
        description.layer.addSublayer(Helper.getBorderOneCorner(size: description.frame.size, edge: .bottom))
        
        view.addSubview(albumView)
        albumView.translatesAutoresizingMaskIntoConstraints = false
        albumView.topAnchor.constraint(equalTo: description.bottomAnchor, constant: Constant.padding).isActive = true
        albumView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.padding).isActive = true
        albumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.padding).isActive = true
        albumView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        albumView.layer.addSublayer(Helper.getBorderOneCorner(size: albumView.frame.size, edge: .bottom))
        
        albumView.addSubview(albumIcon)
        albumIcon.translatesAutoresizingMaskIntoConstraints = false
        albumIcon.centerYAnchor.constraint(equalTo: albumView.centerYAnchor).isActive = true
        albumIcon.leadingAnchor.constraint(equalTo: albumView.leadingAnchor, constant: 5).isActive = true
        albumIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        albumIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        albumView.addSubview(albumLabel)
        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.centerYAnchor.constraint(equalTo: albumIcon.centerYAnchor).isActive = true
        albumLabel.leadingAnchor.constraint(equalTo: albumIcon.trailingAnchor, constant: 5).isActive = true
        
        albumView.addSubview(albumButton)
        albumButton.translatesAutoresizingMaskIntoConstraints = false
        albumButton.centerYAnchor.constraint(equalTo: albumView.centerYAnchor).isActive = true
        albumButton.trailingAnchor.constraint(equalTo: albumView.trailingAnchor, constant: -5).isActive = true
        albumButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        albumButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        view.addSubview(privacyView)
        privacyView.translatesAutoresizingMaskIntoConstraints = false
        privacyView.topAnchor.constraint(equalTo: albumView.bottomAnchor, constant: Constant.padding).isActive = true
        privacyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.padding).isActive = true
        privacyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.padding).isActive = true
        privacyView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        privacyView.layer.addSublayer(Helper.getBorderOneCorner(size: privacyView.frame.size, edge: .bottom))
        
        privacyView.addSubview(privacyIcon)
        privacyIcon.translatesAutoresizingMaskIntoConstraints = false
        privacyIcon.leadingAnchor.constraint(equalTo: privacyView.leadingAnchor, constant: 5).isActive = true
        privacyIcon.centerYAnchor.constraint(equalTo: privacyView.centerYAnchor).isActive = true
        privacyIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        privacyIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        privacyView.addSubview(privacyLabel)
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        privacyLabel.centerYAnchor.constraint(equalTo: privacyView.centerYAnchor).isActive = true
        privacyLabel.leadingAnchor.constraint(equalTo: privacyIcon.trailingAnchor, constant: 5).isActive = true
        
    }
    
}
