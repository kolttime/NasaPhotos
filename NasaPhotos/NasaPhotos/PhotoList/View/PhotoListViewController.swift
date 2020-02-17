//
//  PhotoListViewController.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 15.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RealmSwift

class PhotoListViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate, ToastAlertPresentable {
    
    var toastPresenter: ToastAlertPresenter = ToastAlertPresenter()
    @IBOutlet weak var tableView: UITableView!
    var photos  = PublishSubject<[Photo]>()
    var photoListViewModel = PhotoListViewModel()
    let disposeBag = DisposeBag()
    private let imageView = UIImageView(image: UIImage(named: "nasapic"))
    private struct Const {
     
        static let ImageSizeForLargeState: CGFloat = 40
        
        static let ImageRightMargin: CGFloat = 16
       
        static let ImageBottomMarginForLargeState: CGFloat = 12
       
        static let ImageBottomMarginForSmallState: CGFloat = 6
       
        static let ImageSizeForSmallState: CGFloat = 32

        static let NavBarHeightSmallState: CGFloat = 44
        
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    let backgroundImage : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "background")
        img.contentMode = .scaleToFill
        return img
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
       return  UIStatusBarStyle.lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBindings()
        self.photoListViewModel.requestData()
        self.tableView.delegate = self
        self.setUpNavImage()
        self.tableView.backgroundView = self.backgroundImage
        self.toastPresenter.targetView = self.view
       
    }
    func setupConstraints(){
        self.backgroundImage.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    func setUpNavImage(){
        guard let navigationBar = self.navigationController?.navigationBar else {return}
        navigationBar.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
    }
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    func addAlert(photo : Photo){
        let alert = UIAlertController(title: "Confirm action", message: "Do you want to delete this photo?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            let realm = try! Realm()
            let obj = realm.objects(PhotoRealm.self).filter {
                $0.id == photo.id
            }
            var deletedIds : [Int] = UserDefaults.standard.array(forKey: "deletedIds") as? [Int] ?? []
            deletedIds.append(photo.id)
            UserDefaults.standard.set(deletedIds, forKey: "deletedIds")
            try! realm.write {
                realm.delete(obj.first!)
            }
            self.photoListViewModel.models.accept(
                self.photoListViewModel.models.value.filter { (name) -> Bool in
                    
                    return name.img_src != photo.img_src
                }
            )
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func openFullPhoto(photoUrl : String){
        let vc = FullPhotoViewController()
        vc.imageURL = photoUrl
        present(vc, animated: true, completion: nil)
        //self.present(vc, animated: true, completion: nil)
    }
    func setUpBindings(){
        self.tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: PhotoTableViewCell.self))
        photoListViewModel
                .error
                .observeOn(MainScheduler.instance)
            .subscribe(onNext: {error in
                self.showToastAlert(error)
            })
                .disposed(by: disposeBag)
        photoListViewModel
                .loading
                .bind(to: self.rx.isAnimating)
                .disposed(by: disposeBag)
        photoListViewModel
                .models
                .bind(to: photos)
                .disposed(by: disposeBag)

        photos
            .bind(to: tableView.rx.items(cellIdentifier: "PhotoTableViewCell", cellType: PhotoTableViewCell.self)){
            (row,photo,cell) in
            //cell.photo = photo
                cell.disposeBag = DisposeBag()
                cell.photoImage.rx.tapGesture()
                    .when(.began, .changed, .ended)
                    .subscribe({
                        tap in
                        self.openFullPhoto(photoUrl: photo.img_src)
                    }).disposed(by: cell.disposeBag)
                cell.photoImage.rx.longPressGesture()
                    .when(.began, .changed, .ended)
                    .subscribe(onNext: { pan in
                        self.addAlert(photo: photo)
                    }).disposed(by: cell.disposeBag)
                cell.setPhoto(photo: photo)
            }.disposed(by: disposeBag)
        
    }
   
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }

}

