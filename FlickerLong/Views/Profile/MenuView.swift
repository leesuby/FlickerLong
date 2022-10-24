//
//  MenuView.swift
//  FlickerLong
//
//  Created by LAP15335 on 24/10/2022.
//

import Foundation
import UIKit

protocol MenuViewDelegate{
    func scrollTo(item: Int)
}

class MenuView : UIView{
    var collectionView : UICollectionView!
    var tabs : [String] = ["All Photos","Albums"]
    var slider : UIView!
    var sliderLeftConstraint : NSLayoutConstraint!
    var delegate : MenuViewDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func initMenu(){
        initView()
        initConstraint()
    }
    
    func initView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "menuCell")
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        
        slider = UIView()
        slider.backgroundColor = .gray
    }
    
    func initConstraint(){
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(1.0 / (Double(tabs.count) + 1.0))).isActive = true
        sliderLeftConstraint = slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
        sliderLeftConstraint.isActive = true
        slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init MenuView Error")
    }
}

extension MenuView : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.scrollTo(item: indexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / CGFloat(tabs.count), height: collectionView.frame.size.height)
    }
}

extension MenuView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as? MenuCell{
            
            menuCell.config(title : self.tabs[indexPath.item])
            cell = menuCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
}


