//
//  ToastAlertView.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 17.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import Foundation
import UIKit

class ToastAlertView: UIView {
    
    private var parentWidth: CGFloat = 0
    private let offset = 25
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()
      init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.addSubview(self.textLabel)
        self.setHugging(priority: .required)
        self.invalidateIntrinsicContentSize()
        self.setNeedsUpdateConstraints()
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, parentWidth: CGFloat, backgroundColor: UIColor) {
        self.parentWidth = parentWidth
        self.textLabel.text = text
        self.backgroundColor = backgroundColor
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
    }
    
     func setupConstraints() {
   
        self.textLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(self.offset)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(-self.offset)
        }
    }
    
   
}

