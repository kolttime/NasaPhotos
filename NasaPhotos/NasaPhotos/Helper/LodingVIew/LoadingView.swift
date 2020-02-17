//
//  LoadingView.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 17.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import Foundation
import UIKit

protocol loadingViewable {
    func startAnimating()
    func stopAnimating()
}

class LoadingView : UIView {
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initialSetUp(){
        self.backgroundColor = UIColor.clear
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        //actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.style =
            UIActivityIndicatorView.Style.whiteLarge
        self.addSubview(actInd)
        self.actInd.color = UIColor.white
        actInd.startAnimating()
        self.backgroundColor = UIColor.clear
        self.setupConstraints()
        
    }
    
     func setupConstraints() {
        self.actInd.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
}

extension loadingViewable where Self : UIViewController {
    func startAnimating(){
        let animateLoading = LoadingView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.addSubview(animateLoading)
        view.bringSubviewToFront(animateLoading)
        animateLoading.restorationIdentifier = "loadingView"
        animateLoading.center = view.center
        animateLoading.clipsToBounds = true
        
    }
    func stopAnimating() {
        for item in view.subviews
            where item.restorationIdentifier == "loadingView" {
                UIView.animate(withDuration: 0.3, animations: {
                    item.alpha = 0
                }) { (_) in
                    item.removeFromSuperview()
                }
        }
    }
}
