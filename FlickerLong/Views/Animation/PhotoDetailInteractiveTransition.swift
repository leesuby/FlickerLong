//
//  PhotoDetailInteractiveTransition.swift
//  FlickerLong
//
//  Created by LAP15335 on 04/11/2022.
//

import Foundation
import UIKit
public protocol PhotoDetailTransitionAnimatorDelegate: AnyObject {
    func transitionWillStart()
    func transitionDidEnd()
    func referenceImage() -> UIImage?
    func imageFrame() -> CGRect?
}


public class PhotoDetailInteractiveDismissTransition: NSObject {
    fileprivate let fromDelegate: PhotoDetailTransitionAnimatorDelegate
    fileprivate weak var toDelegate: PhotoDetailTransitionAnimatorDelegate?
    fileprivate var backgroundAnimation: UIViewPropertyAnimator? = nil

    fileprivate var transitionContext: UIViewControllerContextTransitioning? = nil
    fileprivate var fromReferenceImageViewFrame: CGRect? = nil
    fileprivate var toReferenceImageViewFrame: CGRect? = nil
    fileprivate weak var fromVC: PhotoViewController? = nil
    fileprivate weak var toVC: UIViewController? = nil

    fileprivate let transitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    init(fromDelegate: PhotoViewController, toDelegate: Any) {
        self.fromDelegate = fromDelegate
        self.toDelegate = toDelegate as? PhotoDetailTransitionAnimatorDelegate

        super.init()
    }

    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        let transitionContext = self.transitionContext!
        let transitionImageView = self.transitionImageView
        let translation = gestureRecognizer.translation(in: nil)
        let translationVertical = translation.y

        let percentageComplete = self.percentageComplete(forVerticalDrag: translationVertical)
        let transitionImageScale = transitionImageScaleFor(percentageComplete: percentageComplete)

        switch gestureRecognizer.state {
        case .possible, .began:
            break
        case .cancelled, .failed:
            self.completeTransition(didCancel: true)

        case .changed:
            transitionImageView.transform = CGAffineTransform.identity
                .scaledBy(x: transitionImageScale, y: transitionImageScale)
                .translatedBy(x: translation.x, y: translation.y)

            transitionContext.updateInteractiveTransition(percentageComplete)
            self.backgroundAnimation?.fractionComplete = percentageComplete

        case .ended:
            self.completeTransition(didCancel: false)
        @unknown default:
            break
        }
    }

    private func completeTransition(didCancel: Bool) {
        self.backgroundAnimation?.isReversed = didCancel

        let transitionContext = self.transitionContext!
        let backgroundAnimation = self.backgroundAnimation!

        let completionDuration: Double
        let completionDamping: CGFloat
        if didCancel {
            completionDuration = 0.45
            completionDamping = 0.75
        } else {
            completionDuration = 0.37
            completionDamping = 0.90
        }
        
        let foregroundAnimation = UIViewPropertyAnimator(duration: completionDuration, dampingRatio: completionDamping) {
            self.transitionImageView.transform = CGAffineTransform.identity

            self.transitionImageView.frame = didCancel
                ? self.fromReferenceImageViewFrame!
                : self.toDelegate?.imageFrame() ?? self.toReferenceImageViewFrame!
        }

        foregroundAnimation.addCompletion { [weak self] (position) in
            self?.transitionImageView.removeFromSuperview()
            self?.transitionImageView.image = nil
            self?.toDelegate?.transitionDidEnd()
            self?.fromDelegate.transitionDidEnd()

            if didCancel {
                transitionContext.cancelInteractiveTransition()
            } else {
                transitionContext.finishInteractiveTransition()
            }
            transitionContext.completeTransition(!didCancel)
            self?.transitionContext = nil
        }

        let durationFactor = CGFloat(foregroundAnimation.duration / backgroundAnimation.duration)
        backgroundAnimation.continueAnimation(withTimingParameters: nil, durationFactor: durationFactor)
        foregroundAnimation.startAnimation()
    }

    private func percentageComplete(forVerticalDrag verticalDrag: CGFloat) -> CGFloat {
        let maximumDelta = CGFloat(200)
        return CGFloat.scaleAndShift(value: verticalDrag, inRange: (min: CGFloat(0), max: maximumDelta))
    }

    func transitionImageScaleFor(percentageComplete: CGFloat) -> CGFloat {
        let minScale = CGFloat(0.68)
        let result = 1 - (1 - minScale) * percentageComplete
        return result
    }
}

extension PhotoDetailInteractiveDismissTransition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError()
    }
}

extension PhotoDetailInteractiveDismissTransition: UIViewControllerInteractiveTransitioning {
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext

        let containerView = transitionContext.containerView

        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let fromImageFrame = fromDelegate.imageFrame(),
            let fromImage = fromDelegate.referenceImage(),
            let fromVC = transitionContext.viewController(forKey: .from) as? PhotoViewController,
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            fatalError()
        }

        let maybeBackgroundImageView = (fromVC).getImageView()
        let maybeForegroundImageView = (toVC as? ZoomingViewController)?.getImageView()
        
        assert(maybeBackgroundImageView != nil, "Can't find ImageView in backgroundVC")
        assert(maybeForegroundImageView != nil, "Can't find ImageView in foregroundVC")
        
        let fromeImage = maybeBackgroundImageView
        let toImage = maybeForegroundImageView
        
        self.fromVC = fromVC
        self.toVC = toVC
        fromVC.transitionController = self

        fromDelegate.transitionWillStart()
        toDelegate?.transitionWillStart()
        self.fromReferenceImageViewFrame = fromImageFrame

        self.toReferenceImageViewFrame = toImage?.frame

        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(transitionImageView)

        transitionImageView.image = fromImage
        transitionImageView.frame = fromImageFrame

        let animation = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            if self.toDelegate == nil {
                fromView.frame.origin.x = containerView.frame.maxX
                self.transitionImageView.alpha = 0.4
            } else {
                fromView.alpha = 0
                toView.alpha = 1
            }
        })
        self.backgroundAnimation = animation
    }
}
