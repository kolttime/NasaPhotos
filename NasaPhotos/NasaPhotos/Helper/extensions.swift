//
//  extensions.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 17.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


public extension JSONDecoder {
    
    static func makeCamelDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}


extension UIViewController: loadingViewable {}

extension Reactive where Base: UIViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
    
}

public extension UIView {
    public func setHugging(priority: UILayoutPriority) {
        self.setContentHuggingPriority(priority, for: .horizontal)
        self.setContentHuggingPriority(priority, for: .vertical)
    }
    func animateHidden(duration: Double = 0.2, completion: (()->Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 0.0 }) { _ in
            completion?()
        }
    }
    
    func animateShowing(duration: Double = 0.2, completion: (()->Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 1.0 }) { _ in
            completion?()
        }
    }
}

