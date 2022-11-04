//
//  PhotoDetailInteractiveTransition.swift
//  FlickerLong
//
//  Created by LAP15335 on 04/11/2022.
//

import Foundation
import UIKit
public protocol PhotoDetailTransitionAnimatorDelegate: class {

    /// Called just-before the transition animation begins. Use this to prepare your VC for the transition.
    func transitionWillStart()

    /// Called right-after the transition animation ends. Use this to clean up your VC after the transition.
    func transitionDidEnd()

    /// The animator needs a UIImageView for the transition;
    /// eg the Photo Detail screen should provide a snapshotView of its image,
    /// and a collectionView should do the same for its image views.
    func referenceImage() -> UIImage?

    /// The frame for the imageView provided in `referenceImageView(for:)`
    func imageFrame() -> CGRect?
}

/// Controls the "noninteractive push animation" used for the PhotoDetailViewController
public class PhotoDetailPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate let fromDelegate: PhotoDetailTransitionAnimatorDelegate
    fileprivate let photoDetailVC: PhotoViewController

    /// The snapshotView that is animating between the two view controllers.
    fileprivate let transitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    /// If fromDelegate isn't PhotoDetailTransitionAnimatorDelegate, returns nil.
    init?(
        fromDelegate: Any,
        toPhotoDetailVC photoDetailVC: PhotoViewController
    ) {
        guard let fromDelegate = fromDelegate as? PhotoDetailTransitionAnimatorDelegate else {
            return nil
        }
        self.fromDelegate = fromDelegate
        self.photoDetailVC = photoDetailVC
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.38
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // As of 2014, you're meant to use .view(forKey:) instead of .viewController(forKey:).view to get the views.
        // It's not in the original 2013 WWDC talk, but it's in the 2014 one!
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)

        let containerView = transitionContext.containerView
        toView?.alpha = 0
        [fromView, toView]
            .compactMap { $0 }
            .forEach {
                containerView.addSubview($0)
        }
        let transitionImage = fromDelegate.referenceImage()!
        transitionImageView.image = transitionImage
        transitionImageView.frame = fromDelegate.imageFrame()
            ?? PhotoDetailPushTransition.defaultOffscreenFrameForPresentation(image: transitionImage, forView: toView!)
        let toReferenceFrame = PhotoDetailPushTransition.calculateZoomInImageFrame(image: transitionImage, forView: toView!)
        containerView.addSubview(self.transitionImageView)

        self.fromDelegate.transitionWillStart()
        self.photoDetailVC.transitionWillStart()

        let duration = self.transitionDuration(using: transitionContext)
        let spring: CGFloat = 0.95
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: spring) {
            self.transitionImageView.frame = toReferenceFrame
            toView?.alpha = 1
        }
        animator.addCompletion { (position) in
            assert(position == .end)

            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.photoDetailVC.transitionDidEnd()
            self.fromDelegate.transitionDidEnd()
        }
    
        animator.startAnimation()
    }

    /// If no location is provided by the fromDelegate, we'll use an offscreen-bottom position for the image.
    private static func defaultOffscreenFrameForPresentation(image: UIImage, forView view: UIView) -> CGRect {
        var result = PhotoDetailPushTransition.calculateZoomInImageFrame(image: image, forView: view)
        result.origin.y = view.bounds.height
        return result
    }

    /// Because the photoDetailVC isn't laid out yet, we calculate a default rect here.
    // TODO: Move this into PhotoDetailViewController, probably!
    private static func calculateZoomInImageFrame(image: UIImage, forView view: UIView) -> CGRect {
        let rect = CGRect.makeRect(aspectRatio: image.size, insideRect: view.bounds)
        return rect
    }
}


public class PhotoDetailPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate let toDelegate: PhotoDetailTransitionAnimatorDelegate
    fileprivate let photoDetailVC: PhotoViewController

    /// The snapshotView that is animating between the two view controllers.
    fileprivate let transitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    /// If toDelegate isn't PhotoDetailTransitionAnimatorDelegate, returns nil.
    init?(
        toDelegate: Any,
        fromPhotoDetailVC photoDetailVC: PhotoViewController
        ) {
        guard let toDelegate = toDelegate as? PhotoDetailTransitionAnimatorDelegate else {
            return nil
        }

        self.toDelegate = toDelegate
        self.photoDetailVC = photoDetailVC
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.38
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        let fromReferenceFrame = photoDetailVC.imageFrame()!

        let transitionImage = photoDetailVC.referenceImage()
        transitionImageView.image = transitionImage
        transitionImageView.frame = photoDetailVC.imageFrame()!

        [toView, fromView]
            .compactMap { $0 }
            .forEach { containerView.addSubview($0) }
        containerView.addSubview(transitionImageView)

        self.photoDetailVC.transitionWillStart()
        self.toDelegate.transitionWillStart()

        let duration = self.transitionDuration(using: transitionContext)
        let spring: CGFloat = 0.9
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: spring) {
            fromView?.alpha = 0
        }
        animator.addCompletion { (position) in
            assert(position == .end)

            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.toDelegate.transitionDidEnd()
            self.photoDetailVC.transitionDidEnd()
        }
        animator.startAnimation()

        // HACK: By delaying 0.005s, I get a layout-refresh on the toViewController,
        // which means its collectionview has updated its layout,
        // and our toDelegate?.imageFrame() is accurate, even if
        // the device has rotated. :scream_cat:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            animator.addAnimations {
                let toReferenceFrame = self.toDelegate.imageFrame() ??
                    PhotoDetailPopTransition.defaultOffscreenFrameForDismissal(
                        transitionImageSize: fromReferenceFrame.size,
                        screenHeight: containerView.bounds.height
                )
                self.transitionImageView.frame = toReferenceFrame
            }
        }
    }

    /// If we need a "dummy reference frame", let's throw the image off the bottom of the screen.
    /// Photos.app transitions to CGRect.zero, though I think that's ugly.
    public static func defaultOffscreenFrameForDismissal(
        transitionImageSize: CGSize,
        screenHeight: CGFloat
    ) -> CGRect {
        return CGRect(
            x: 0,
            y: screenHeight,
            width: transitionImageSize.width,
            height: transitionImageSize.height
        )
    }
}


public class PhotoDetailInteractiveDismissTransition: NSObject {
    /// The from- and to- viewControllers can conform to the protocol in order to get updates and vend snapshotViews
    fileprivate let fromDelegate: PhotoDetailTransitionAnimatorDelegate
    fileprivate weak var toDelegate: PhotoDetailTransitionAnimatorDelegate?

    /// The background animation is the "photo-detail background opacity goes to zero"
    fileprivate var backgroundAnimation: UIViewPropertyAnimator? = nil

    // NOTE: To avoid writing tons of boilerplate that pulls these values out of
    // the transitionContext, I'm just gonna cache them here.
    fileprivate var transitionContext: UIViewControllerContextTransitioning? = nil
    fileprivate var fromReferenceImageViewFrame: CGRect? = nil
    fileprivate var toReferenceImageViewFrame: CGRect? = nil
    fileprivate weak var fromVC: PhotoViewController? = nil
    fileprivate weak var toVC: UIViewController? = nil

    /// The snapshotView that is animating between the two view controllers.
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

    /// Called by the photo-detail screen, this function updates the state of
    /// the interactive transition, based on the state of the gesture.
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        let transitionContext = self.transitionContext!
        let transitionImageView = self.transitionImageView
        let translation = gestureRecognizer.translation(in: nil)
        let translationVertical = translation.y

        // For a given vertical-drag, we calculate our percentage complete
        // and how shrunk-down the transition-image should be.
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
            // Here, we decide whether to complete or cancel the transition.
            self.completeTransition(didCancel: false)
        @unknown default:
            break
        }
    }

    private func completeTransition(didCancel: Bool) {
        // If the gesture was cancelled, we reverse the "fade out the photo-detail background" animation.
        self.backgroundAnimation?.isReversed = didCancel

        let transitionContext = self.transitionContext!
        let backgroundAnimation = self.backgroundAnimation!

        // The cancel and complete animations have different timing values.
        // I dialed these in on-device using SwiftTweaks.
        let completionDuration: Double
        let completionDamping: CGFloat
        if didCancel {
            completionDuration = 0.45
            completionDamping = 0.75
        } else {
            completionDuration = 0.37
            completionDamping = 0.90
        }

        // The transition-image needs to animate into its final place.
        // That's either:
        // - its original spot on the photo-detail screen (if the transition was cancelled),
        // - or its place in the photo-grid (if the transition completed).
        let foregroundAnimation = UIViewPropertyAnimator(duration: completionDuration, dampingRatio: completionDamping) {
            // Reset our scale-transform on the imageview
            self.transitionImageView.transform = CGAffineTransform.identity

            // NOTE: It's important that we ask the toDelegate *here*,
            // because if the device has rotated,
            // the toDelegate needs a chance to update its layout
            // before asking for the frame.
            self.transitionImageView.frame = didCancel
                ? self.fromReferenceImageViewFrame!
                : self.toDelegate?.imageFrame() ?? self.toReferenceImageViewFrame!
        }

        // When the transition-image has moved into place, the animation completes,
        // and we close out the transition itself.
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

        // Update the backgroundAnimation's duration to match.
        // PS: How *cool* are property-animators? I say: very. This "continue animation" bit is magic!
        let durationFactor = CGFloat(foregroundAnimation.duration / backgroundAnimation.duration)
        backgroundAnimation.continueAnimation(withTimingParameters: nil, durationFactor: durationFactor)
        foregroundAnimation.startAnimation()
    }

    /// For a given vertical offset, what's the percentage complete for the transition?
    /// e.g. -100pts -> 0%, 0pts -> 0%, 20pts -> 10%, 200pts -> 100%, 400pts -> 100%
    private func percentageComplete(forVerticalDrag verticalDrag: CGFloat) -> CGFloat {
        let maximumDelta = CGFloat(200)
        return CGFloat.scaleAndShift(value: verticalDrag, inRange: (min: CGFloat(0), max: maximumDelta))
    }

    /// The transition image scales down from 100% to a minimum of 68%,
    /// based on the percentage-complete of the gesture.
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
        // Never called; this is always an interactive transition.
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

        // We'll replace this with a better one during the transition,
        // because the collectionviews on the parent screen need a chance to re-layout.
        self.toReferenceImageViewFrame = toImage?.frame

        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(transitionImageView)

        transitionImageView.image = fromImage
        transitionImageView.frame = fromImageFrame

        // NOTE: The duration and damping ratio here don't matter!
        // This animation is only programmatically adjusted in the drag state,
        // and then the duration is altered in the completion state.
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
