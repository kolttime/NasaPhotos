//
//  FullPhotoViewController.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 16.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import UIKit

class FullPhotoViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
  
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL : String!
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.scrollView.maximumZoomScale = 10.0
        self.scrollView.minimumZoomScale = 1.0
        self.imageView.kf.setImage(with: URL(string: self.imageURL))
        self.scrollView.backgroundColor = UIColor.black
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler(_:)))
        pan.delegate = self
        self.scrollView.addGestureRecognizer(pan)

    }
   
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {

        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

}
