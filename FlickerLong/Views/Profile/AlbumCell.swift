//
//  AlbumCell.swift
//  FlickerLong
//
//  Created by LAP15335 on 24/10/2022.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    private var cover : UIImageView!
    private var title : UILabel!
    private var date : UILabel!
    private var numberPhotos : UILabel!
    var albumModel : AlbumModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        initConstraint()
    }
    
    func initView(){
        cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        
        title = UILabel()
        title.font = Constant.Title.font
        title.textColor = Constant.Title.color
        
        date = UILabel()
        date.font = Constant.SubTitle.font
        date.textColor = Constant.SubTitle.color
        
        numberPhotos = UILabel()
        numberPhotos.font = Constant.SubTitle.font
        numberPhotos.textColor = Constant.SubTitle.color
    }
    
    func initConstraint(){
        addSubview(cover)
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.padding).isActive = true
        cover.topAnchor.constraint(equalTo: topAnchor, constant: Constant.padding).isActive = true
        cover.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.padding).isActive = true
        cover.widthAnchor.constraint(equalTo: heightAnchor, constant: -Constant.padding * 2).isActive = true
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: Constant.padding ).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: Constant.padding).isActive = true
        
        addSubview(numberPhotos)
        numberPhotos.translatesAutoresizingMaskIntoConstraints = false
        numberPhotos.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: Constant.padding).isActive = true
        numberPhotos.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.padding).isActive = true
        
        addSubview(date)
        date.translatesAutoresizingMaskIntoConstraints = false
        date.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: Constant.padding).isActive = true
        date.bottomAnchor.constraint(equalTo: numberPhotos.topAnchor, constant: -Constant.padding / 2).isActive = true
        
    }
    
    func config(album : AlbumModel){
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: album.coverURL)
            
            DispatchQueue.main.async {
                self.cover.image = UIImage(data: data!)
                self.title.text = album.title
                self.date.text = Helper.getDateStringFromUTC(time: Int(album.dateCreated)!)
                self.numberPhotos.text = "\(String(album.numberOfPhotos)) photos"
                self.albumModel = album
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error create AlbumCell")
    }
}
