//
//  PhotoTableViewCell.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 15.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift
import RxCocoa

class PhotoTableViewCell: UITableViewCell {
   
    let photoImage = UIImageView()
    var disposeBag : DisposeBag!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.addSubview(self.photoImage)
        self.photoImage.contentMode = .scaleAspectFill
        self.photoImage.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
        self.setUpConstraints()
        
    }
    func setUpConstraints(){
        
        self.photoImage.snp.makeConstraints{
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    public var cellPhoto : Photo!
    
    func setPhoto(photo : Photo){
        self.cellPhoto = photo
        self.photoImage.kf.setImage(with: URL(string: photo.img_src))
    }
    
}
