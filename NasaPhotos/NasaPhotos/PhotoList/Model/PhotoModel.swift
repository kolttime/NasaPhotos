//
//  PhotoModel.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 15.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import Foundation


struct Photo : Codable {
   // let id : Int
    let id : Int
    let img_src : String
    
}
struct Photos : Codable {
    let photos : [Photo]
}
extension Photos{
    init?(data : Data) {
        guard let me = try? JSONDecoder().decode(Photos.self, from: data) else {return nil}
        self = me
    }
}

extension Photo{
    init?(data : Data) {
        guard let me = try? JSONDecoder().decode(Photo.self, from: data) else {return nil}
        self = me
    }
}
extension Array where Element == Photo {
    
    init(data: Data) throws {
        let decoder = JSONDecoder.makeCamelDecoder()
        self = try decoder.decode([Photo].self, from: data)
    }
}
