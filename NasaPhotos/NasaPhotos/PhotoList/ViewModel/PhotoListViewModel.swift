//
//  PhotoListViewModel.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 15.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift




class PhotoListViewModel {
    
    
    
   
    public let loading : PublishSubject<Bool> = PublishSubject()
    public let models = BehaviorRelay<[Photo]>(value: [])
    public let error : PublishSubject<String> = PublishSubject()
    
    private let disposable = DisposeBag()
    init() {
       
    }
    public func requestData(){
        self.loading.onNext(true)
        let realm = try! Realm()
        var photos : [Photo] = []
        realm.objects(PhotoRealm.self).forEach{ photoRealm in
            let photo = Photo(id: photoRealm.id, img_src: photoRealm.img_src)
            
            photos.append(photo)
        }
        self.models.accept(photos)
        ApiService.apiService.requestFetchPhotoList { (photo, error) in
            
            self.loading.onNext(false)
            
            
            if let error = error {
                self.error.onNext(error.localizedDescription)
            } else {
                
                var photos : [Photo] = []
                let allPhotosrealm = realm.objects(PhotoRealm.self)
                try! realm.write{
                    realm.delete(allPhotosrealm)
                }
                let deletedIds : [Int] = UserDefaults.standard.array(forKey: "deletedIds") as? [Int] ?? []
                
                photo!.photos.forEach{ photo in
                    if deletedIds.first(where: {$0 == photo.id}) == nil {
                        let photoRealm = PhotoRealm()
                        photoRealm.id = photo.id
                        photoRealm.img_src = photo.img_src
                        try! realm.write {
                            realm.add(photoRealm)
                        }
                        photos.append(photo)
                    }
                    
                }
                self.models.accept(photos)
            
            }
        }
    }
}
