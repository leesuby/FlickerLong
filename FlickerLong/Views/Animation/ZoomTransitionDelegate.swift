//
//  ZoomTransitionDelegate.swift
//  FlickerLong
//
//  Created by LAP15335 on 03/11/2022.
//

import Foundation
import UIKit

@objc
protocol ZoomingViewController {
    func zoomingImageView(for transition : ZoomTransitioningDelgate) -> UIImageView?
}

enum TransitionState{
    case initial
    case final
}

class ZoomTransitioningDelgate : NSObject{
    var transitionDuration = 0.7
    var operation : UINavigationController.Operation = .none
    private let zoomScale = CGFloat(15)
    private let backgroundScale = CGFloat(0.7)
    
    typealias ZoomingViews = (UIView)
    
    func configureView(for state: TransitionState, containerView: UIView, backgroundViewController : UIViewController, viewsInBackground: ZoomingViews, foregroundViewController: UIViewController, viewsInForeground: ZoomingViews, snapshotView: ZoomingViews){
        
        switch state{
        case .initial:
            backgroundViewController.view.transform = CGAffineTransform.identity
            backgroundViewController.view.alpha = 1
            
            snapshotView.frame = containerView.convert(viewsInBackground.frame, from: viewsInBackground.superview)
            
        case .final:
            backgroundViewController.view.transform = CGAffineTransform(scaleX: backgroundScale, y: backgroundScale)
            backgroundViewController.view.alpha = 0
            
            snapshotView.frame = containerView.convert(viewsInForeground.frame, from: viewsInForeground.superview)
        }
    }
}

extension ZoomTransitioningDelgate : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let viewContainer = transitionContext.containerView
        
        var backgroundVC = fromVC
        var foregroundVC = toVC
        
        if(operation == .pop){
            backgroundVC = toVC
            foregroundVC = fromVC
        }
        
        let maybeBackgroundImageView = (backgroundVC as? ZoomingViewController)?.zoomingImageView(for: self)
        let maybeForegroundImageView = (foregroundVC as? ZoomingViewController)?.zoomingImageView(for: self)
        
        assert(maybeBackgroundImageView != nil, "Can't find ImageView in backgroundVC")
        assert(maybeForegroundImageView != nil, "Can't find ImageView in foregroundVC")
        
        let backgroundImageView = maybeBackgroundImageView
        let foregroundImageView = maybeForegroundImageView
        
        let imageViewSnapshot = UIImageView(image: backgroundImageView?.image)
        imageViewSnapshot.layer.masksToBounds = true
        
        backgroundImageView?.isHidden = true
        foregroundImageView?.isHidden = true
        
        let foregroundViewBackgroundColor = foregroundVC.view.backgroundColor
        foregroundVC.view.backgroundColor = .clear
        viewContainer.backgroundColor = .white
        
        viewContainer.addSubview(backgroundVC.view)
        viewContainer.addSubview(foregroundVC.view)
        viewContainer.addSubview(imageViewSnapshot)
        
        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final
        imageViewSnapshot.contentMode = .scaleAspectFill
        
        if(operation == .pop){
            preTransitionState = .final
            postTransitionState = .initial
            imageViewSnapshot.contentMode = .scaleAspectFit
        }
        
        
        configureView(for: preTransitionState, containerView: viewContainer, backgroundViewController: backgroundVC, viewsInBackground: backgroundImageView!, foregroundViewController: foregroundVC, viewsInForeground: foregroundImageView!, snapshotView: imageViewSnapshot)
        
        foregroundVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0) {
            imageViewSnapshot.contentMode = .scaleAspectFit
            
            if(self.operation == .pop){
                imageViewSnapshot.contentMode = .scaleAspectFill
            }
            
            self.configureView(for: postTransitionState, containerView: viewContainer, backgroundViewController: backgroundVC, viewsInBackground: backgroundImageView!, foregroundViewController: foregroundVC, viewsInForeground: foregroundImageView!, snapshotView: imageViewSnapshot)
            
        } completion: { (finished) in
            backgroundVC.view.transform = CGAffineTransform.identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImageView?.isHidden = false
            foregroundImageView?.isHidden = false
            foregroundVC.view.backgroundColor = foregroundViewBackgroundColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        
    }
    
    
}

extension ZoomTransitioningDelgate : UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is ZoomingViewController && toVC is ZoomingViewController{
            self.operation = operation
            return self
        }else{
            return nil
        }
    }
}
