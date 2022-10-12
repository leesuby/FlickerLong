//
//  OnboardingView.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import Foundation
import UIKit


protocol OnboardingViewDelegate{
    func getStartTapped()
}

class OnboardingView{
    private var view : UIView
    var delegate : OnboardingViewDelegate!
    
    init(view: UIView) {
        self.view = view
    }
    
    private var background : UIImageView!
    private var logo : UIImageView!
    private var description : UILabel!
    private var getStartButton: UIButton!
    
    func initView(){
        background = UIImageView()
        background.image = UIImage(named: Constant.BackgroundOnboarding.imageName)
        background.contentMode = .scaleAspectFill
        
        logo = UIImageView()
        logo.image = UIImage(named: Constant.Logo.imageName)
        logo.contentMode = .scaleAspectFit
        logo.transform = logo.transform.rotated(by: Constant.Logo.logoRotate)
        
        description = UILabel()
        description.text = "Find photo you love\nDiscover photographer you like"
        description.font = Constant.Description.font
        description.textColor = Constant.Description.color
        description.textAlignment = Constant.Description.textAlightment
        description.backgroundColor = .clear
        description.numberOfLines = 0
        
        getStartButton = UIButton()
        getStartButton.setTitle("Get Started", for: .normal)
        getStartButton.titleLabel?.font = .NunitoBold(size: 24)
        getStartButton.setImage(UIImage(named: "ArrowRight"), for: .normal)
        getStartButton.imageView?.contentMode = .scaleAspectFit
        getStartButton.backgroundColor = .white80a
        getStartButton.layer.cornerRadius = 30
        getStartButton.setTitleColor(.black, for: .normal)
        getStartButton.textCenterImageRightAlignment()
    }
    
    func initConstraint(){
        
        view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        background.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(description)
        description.translatesAutoresizingMaskIntoConstraints = false
        description.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150).isActive = true
        description.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(getStartButton)
        getStartButton.translatesAutoresizingMaskIntoConstraints = false
        getStartButton.centerYAnchor.constraint(equalTo: description.centerYAnchor, constant: 100).isActive = true
        getStartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getStartButton.widthAnchor.constraint(equalToConstant: view.frame.width - 60).isActive = true
        getStartButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        getStartButton.addTarget(self, action: #selector(getStartButtonTapped), for: .touchUpInside)
    }
    
    @objc func getStartButtonTapped(){
        self.delegate.getStartTapped()
    }
}
