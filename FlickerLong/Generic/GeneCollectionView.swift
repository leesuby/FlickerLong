//
//  GeneCollectionView.swift
//  FlickerLong
//
//  Created by LAP15335 on 12/10/2022.
//

import Foundation
import UIKit

class GeneCollectionView<CELL : UICollectionViewCell,T> : NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var cellIdentifier : String!
    private var items : [T]!
    private var configureCell : (CELL, T) -> () = {_,_ in }
    private var configureSizeForItemAt : ((Int) -> CGSize) = {_ in return CGSize.zero}
    
    //CONFIG
    func configureCell(config: @escaping (CELL, T) -> ()){
        self.configureCell = config
    }
    
    func configureSizeForItemAt(config: @escaping (Int) -> CGSize){
        self.configureSizeForItemAt = config
    }
    
    init(cellIdentifier : String, items : [T]) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
    }
    
    
    //DATA SOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CELL
        let item = self.items[indexPath.row]
        self.configureCell(cell, item)
        return cell
    }
    
    //FLOW LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        configureSizeForItemAt(indexPath.item)
    }
    
}



