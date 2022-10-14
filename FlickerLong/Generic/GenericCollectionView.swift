//
//  GeneCollectionView.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import Foundation
import UIKit

// MARK: Generic type for datasource UICollectionView
class GenericCollectionViewDataSource<T> : NSObject, UICollectionViewDataSource{
    
    var items : [T]!
    private var configureCell : (_ indexPath: IndexPath) -> (UICollectionViewCell) = {_ in return UICollectionViewCell()}
    
    init(items : [T]) {
        self.items =  items
    }
    
    //CONFIG
    func setConfigureCell(config: @escaping (_ indexPath: IndexPath) -> (UICollectionViewCell)){
        self.configureCell = config
    }
   
    //DATA SOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.configureCell(indexPath)
        return cell
    }
    

}

// MARK: Generic type for delegate UICollectionView
class GenericCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var configureSizeForItemAt : ((Int) -> CGSize) = {_ in return CGSize.zero}
    
    //CONFIG
    func setConfigureSizeForItemAt(config: @escaping (Int) -> CGSize){
        self.configureSizeForItemAt = config
    }
    
    //FLOW LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        configureSizeForItemAt(indexPath.item)
    }

}

