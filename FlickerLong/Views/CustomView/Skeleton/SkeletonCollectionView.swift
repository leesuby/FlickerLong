//
//  SkeletonCollectionView.swift
//  FlickerLong
//
//  Created by LAP15335 on 16/11/2022.
//

import UIKit

extension UICollectionView{
    struct SkeletonHolder{
        static var skeletonAmount : Int?
        static var listSkeleton: [CGFloat]?
    }
    
    var skeletonAmount : Int? {
        get {
            return SkeletonHolder.skeletonAmount
        }
        set {
            SkeletonHolder.skeletonAmount = newValue
            createListSkeleton()
        }
    }
    
    var listSkeleton : [CGFloat]{
        get{
            return SkeletonHolder.listSkeleton ?? [0]
        }
    }
    
    private func createListSkeleton(){
        var list : [CGFloat] = []
        var base : CGFloat = 1  // 100% width
        
        for i in 0..<(skeletonAmount ?? 0){
            if(i == skeletonAmount! - 1){
                list.append(base)
                break
            }
            let widthRatio = Double.random(in: 0.25...base)
            
            if(base - widthRatio < 0.25){
                list.append(base)
                base = 1
            }else{
                base = base - widthRatio
                list.append(widthRatio)
            }
        }
        
        SkeletonHolder.listSkeleton = list
    }
}
