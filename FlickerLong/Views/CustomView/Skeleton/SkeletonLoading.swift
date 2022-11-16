//
//  SkeletonLoading.swift
//  FlickerLong
//
//  Created by LAP15335 on 14/11/2022.
//

import Foundation
import UIKit

protocol SkeletonLoading{
    var skeletonLayer : CAGradientLayer? {get set}
    var realBound : CGRect? {get set}
    var isSkeletonLoading : Bool? {get set}
    func startLoading()
    func stopLoading()
    func initLayer()
    func makeAnimationGroup(previousGroup: CAAnimationGroup?) -> CAAnimationGroup
}


extension UIView : SkeletonLoading{
    // Holder : Using to store property in extension
    struct Holder {
        static var skeletonLayer : CAGradientLayer?
    }
    
    var skeletonLayer : CAGradientLayer?{
        get {
            return Holder.skeletonLayer
        }
        set(newValue) {
            Holder.skeletonLayer = newValue
        }
    }
    
    var realBound : CGRect? {
        set {
            bounds = newValue ?? bounds
        }
        
        get {
            return bounds
        }
    }
    
    var isSkeletonLoading : Bool? {
        set {
            switch newValue{
            case true:
                startLoading()
            case false:
                stopLoading()
            default:
                print("SKELETON LOADING : Please set true/false value on isSkeletonLoading")
            }
        }
        get{
            return nil
        }
    }
    
    internal func startLoading(){
        initLayer()
    }
    
    //TODO: Remove exactly skeleton layer (Not Done But Still Running)
    internal func stopLoading(){
        //skeletonLayer?.removeFromSuperlayer()
        layer.sublayers?.removeLast(1)
    }
    
    internal func initLayer(){
        skeletonLayer = CAGradientLayer()
        skeletonLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        skeletonLayer?.endPoint = CGPoint(x: 1, y: 0.5)
        
        layer.addSublayer(skeletonLayer!)
        
        let animationGroup = makeAnimationGroup()
        animationGroup.beginTime = 0.0
        skeletonLayer!.add(animationGroup, forKey: "backgroundColor")
        
        skeletonLayer!.frame = realBound ?? .zero
        skeletonLayer!.cornerRadius = 10
        
    }
    
    internal func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup{
        let animationDuration: CFTimeInterval = 0.6
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.lightGray.cgColor
        anim1.toValue = UIColor.white.cgColor
        anim1.beginTime = 0
        anim1.duration = animationDuration
        
        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.white.cgColor
        anim2.toValue = UIColor.lightGray.cgColor
        anim2.beginTime = anim1.beginTime + anim1.duration
        anim2.duration = animationDuration
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [anim1,anim2]
        animationGroup.repeatCount = .greatestFiniteMagnitude
        animationGroup.duration = anim2.duration + anim2.beginTime
        animationGroup.isRemovedOnCompletion = false
        
        if let previousGroup = previousGroup {
            animationGroup.beginTime = previousGroup.duration + 0.33
        }
        
        return animationGroup
    }
}
