//
//  PhotoViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 03/11/2022.
//

import UIKit

class PhotoViewController: UIViewController {
    
    private var photoView : PhotoViewUI!
    var image : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoView = PhotoViewUI(vc: self, image: image)

        // Do any additional setup after loading the view.
    }

}

extension PhotoViewController : ZoomingViewController{
    func zoomingImageView(for transition: ZoomTransitioningDelgate) -> UIImageView? {
        return photoView.imageView
    }
}
