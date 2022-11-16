//
//  InformationView.swift
//  FlickerLong
//
//  Created by LAP15335 on 17/10/2022.
//

import Foundation
import UIKit

enum TypeInformation{
    case haveSubtitle
    case noSubtitle
}

protocol InformationViewDelegate {
    func actionButton()
}

class InformationView : UIView{
    private var image : UIImageView!
    private var title : UILabel!
    private var detail: UILabel!
    private var buttonAction: UIButton!
    var delegate : InformationViewDelegate!
    
    init(frame: CGRect,isHaveSubtitle: Bool) {
        super.init(frame: frame)
        
        initView()
        initConstraint(isHaveSubtitle: isHaveSubtitle)
    }
    
    func config(nameImage: String ,title: String, subtitle: String, buttonTitle: String, type: TypeInformation){
        switch type{
        case.haveSubtitle:
            self.image.image = UIImage(named: nameImage)
            self.title.text = title
            self.detail.text = subtitle
            self.buttonAction.setTitle(buttonTitle, for: .normal)
            self.buttonAction.titleLabel?.font = .NunitoBold(size: 14)
        case.noSubtitle:
            self.image.image = UIImage(named: nameImage)
            self.title.text = title
            self.buttonAction.setTitle(buttonTitle, for: .normal)
            self.buttonAction.titleLabel?.font = .NunitoBold(size: 14)
        }
        
    }
    
    func initView(){
        image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        
        title = UILabel()
        title.font = Constant.Title.font
        title.textAlignment = Constant.Title.textAlightment
        title.textColor = Constant.Title.color
        title.numberOfLines = 0
        title.backgroundColor = .clear
        
        detail = UILabel()
        detail.font = Constant.SubTitle.font
        detail.textAlignment = Constant.Title.textAlightment
        detail.textColor = Constant.Title.color
        detail.numberOfLines = 0
        detail.backgroundColor = .clear
        
        buttonAction = UIButton()
        buttonAction.backgroundColor = .lightGray
        buttonAction.layer.cornerRadius = 20
        buttonAction.setTitleColor(.black, for: .normal)
        buttonAction.isEnabled = true
        buttonAction.isUserInteractionEnabled = true
    }
    
    func initConstraint(isHaveSubtitle : Bool){
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5).isActive = true
        title.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        addSubview(detail)
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        detail.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        addSubview(buttonAction)
        buttonAction.translatesAutoresizingMaskIntoConstraints = false
        if(isHaveSubtitle){
            buttonAction.topAnchor.constraint(equalTo: detail.bottomAnchor, constant: 5).isActive = true
        }
        else{
            buttonAction.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        }
        buttonAction.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        buttonAction.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -100).isActive = true
        buttonAction.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonAction.addTarget(self, action: #selector(actionOnButton), for: .touchUpInside)
    }
    
    @objc func actionOnButton(){
        guard let del = self.delegate else{
            return
        }
        del.actionButton()
    }
    

    required init?(coder: NSCoder) {
        fatalError("Error create Information")
    }
    
    
}
