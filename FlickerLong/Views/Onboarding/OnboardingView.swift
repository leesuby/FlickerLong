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
    
    private let background : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constant.BackgroundOnboarding.imageName)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let logo : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constant.Logo.imageName)
        image.contentMode = .scaleAspectFit
        image.transform = image.transform.rotated(by: Constant.Logo.logoRotate)
        return image
    }()
    
    private let description : UILabel = {
        let label = UILabel()
        label.text = "Find photo you love\nDiscover photographer you like"
        label.font = Constant.Description.font
        label.textColor = Constant.Description.color
        label.textAlignment = Constant.Description.textAlightment
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    private let getStartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = .NunitoBold(size: 24)
        button.setImage(UIImage(named: "ArrowRight"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .white80a
        button.layer.cornerRadius = 30
        button.setTitleColor(.black, for: .normal)
        button.textCenterImageRightAlignment()
        return button
    }()
    
    func initViewConstraint(){
        
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
