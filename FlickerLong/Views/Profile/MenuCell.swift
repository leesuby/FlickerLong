//
//  MenuCell.swift
//  FlickerLong
//
//  Created by LAP15335 on 24/10/2022.
//

import UIKit

class MenuCell : UICollectionViewCell{
    private var title : UILabel!
    
    override var isHighlighted: Bool{
        didSet{
            title.textColor = isHighlighted ? Constant.Title.color : .lightGray
        }
    }
    
    override var isSelected: Bool{
        didSet{
            title.textColor = isSelected ? Constant.Title.color : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        initConstraint()
    }
    
    func initView(){
        title = UILabel()
        title.font = .NunitoExtraBold(size: 18)
        title.textColor = .lightGray
        title.textAlignment = Constant.Title.textAlightment
        
    }
    
    func initConstraint(){
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func config(title: String){
        self.title.text = title
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Error Create MenuCell")
    }
}
