//
//  ToastAlert.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 17.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import Foundation
import UIKit

protocol ToastAlertPresentable: class {
    var toastPresenter: ToastAlertPresenter { get }
}

class ToastAlertPresenter {
    
    private lazy var toast = ToastAlertView()
    
    private var dismissWorkItem: DispatchWorkItem?
    
    weak var targetView: UIView?
    var bottomOffset: CGFloat = 0
    
    func presentToast(text: String, backgroundColor: UIColor) {
        guard let targetWidth = self.targetView?.bounds.width else { return }
        self.toast.alpha = 0.0
        self.dismiss()
        self.toast.configure(text: text, parentWidth: targetWidth, backgroundColor: backgroundColor)
        self.targetView?.addSubview(self.toast)
        self.toast.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
            $0.bottom.equalToSuperview().offset(-self.bottomOffset)
        }
        self.scheduleDismiss(after: 2)
        self.toast.animateShowing()
    }
    
    
    private func dismissToast() {
       self.toast.animateHidden(duration: 0.2) {
            self.toast.removeFromSuperview()
        }
    }
    
    func dismiss() {
        self.cancelDismiss()
        self.toast.removeFromSuperview()
    }
}

private extension ToastAlertPresenter {
    
    func scheduleDismiss(after: TimeInterval) {
        self.dismissWorkItem = DispatchWorkItem { [weak self] in
            self?.dismissToast()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + after, execute: self.dismissWorkItem!)
    }
    
    func cancelDismiss() {
        self.dismissWorkItem?.cancel()
        self.dismissWorkItem = nil
    }
}

extension ToastAlertPresentable where Self: UIViewController {

    func showToastAlert(_ text: String) {
        
        self.toastPresenter.bottomOffset = 100
        
        self.toastPresenter.presentToast(text: text, backgroundColor: UIColor.red)
    }
}
