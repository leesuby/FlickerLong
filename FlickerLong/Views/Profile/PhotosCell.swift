//
//  PhotosCell.swift
//  FlickerLong
//
//  Created by LAP15335 on 24/10/2022.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func config(color: UIColor){
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error create photosCell")
    }
}
