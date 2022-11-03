//
//  PhotoView.swift
//  FlickerLong
//
//  Created by LAP15335 on 03/11/2022.
//

import Foundation
import UIKit

class PhotoViewUI{
    var viewController : UIViewController
    var view : UIView!
    var imageView : UIImageView!
    
    init(vc: UIViewController, image: UIImage){
        self.viewController = vc
        self.view = vc.view
        initView(image : image)
        initConstraint()
    }
    
    func initView(image : UIImage){
        imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        view.backgroundColor = .white
    }
    
    func initConstraint(){
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
}
