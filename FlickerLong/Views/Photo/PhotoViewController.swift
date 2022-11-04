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
        configureDismissGesture()
    }

    private let dismissPanGesture = UIPanGestureRecognizer()
    public var isInteractivelyDismissing: Bool = false

    // By holding this as a property, we can then notify it about the current
    // state of the pan-gesture as the user moves their finger around.
    public weak var transitionController: PhotoDetailInteractiveDismissTransition? = nil

    // We'll call this in viewDidLoad to set up the gesture
    private func configureDismissGesture() {
        self.view.addGestureRecognizer(self.dismissPanGesture)
        self.dismissPanGesture.addTarget(self, action: #selector(dismissPanGestureDidChange(_:)))
    }

    @objc private func dismissPanGestureDidChange(_ gesture: UIPanGestureRecognizer) {
        // Decide whether we're interactively-dismissing, and notify our navigation controller.
        switch gesture.state {
        case .began:
            self.isInteractivelyDismissing = true
            self.navigationController?.popViewController(animated: true)
        case .cancelled, .failed, .ended:
            self.isInteractivelyDismissing = false
        case .changed, .possible:
            break
        @unknown default:
            break
        }

        // ...and here's where we pass up the current-state of our gesture
        // to our `PhotoDetailInteractiveDismissTransition`:
        self.transitionController?.didPanWith(gestureRecognizer: gesture)
    }
}

extension PhotoViewController : ZoomingViewController{
    func getImageView() -> UIImageView? {
        return photoView.imageView
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelgate) -> UIImageView? {
        return photoView.imageView
    }

}


extension PhotoViewController: PhotoDetailTransitionAnimatorDelegate {
    func transitionWillStart() {
        self.photoView.imageView.isHidden = true
    }

    func transitionDidEnd() {
        self.photoView.imageView.isHidden = false
    }

    func referenceImage() -> UIImage? {
        return self.photoView.imageView.image
    }

    func imageFrame() -> CGRect? {
        let rect = CGRect.makeRect(aspectRatio: photoView.imageView.image!.size, insideRect: photoView.imageView.bounds)
        return rect
    }
}
