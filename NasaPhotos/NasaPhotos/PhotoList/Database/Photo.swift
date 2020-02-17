//
//  Photo.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 16.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import Foundation
import RealmSwift

class PhotoRealm : Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var img_src : String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
