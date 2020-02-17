//
//  ApiService.swift
//  NasaPhotos
//
//  Created by Роман Макеев on 15.02.2020.
//  Copyright © 2020 Роман Макеев. All rights reserved.
//

import Foundation
import Alamofire


class ApiService {
    static let apiService = ApiService()
    private var endpoint = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=1&api_key=OX7ZOzivUtOZP8VqMi5gCBQEpg4B75f1zbu9Qjz0"
    let decoder = JSONDecoder()

    func requestFetchPhotoList(completion: @escaping (Photos?, Error?)-> ()){
        
        AF.request(endpoint).responseDecodable(of: Photos.self, decoder: decoder) { (data) in
            
            if let error = data.error {
                completion(nil, error)
                return
            }
            if let photos = data.value {
                completion(photos, nil)
            }
        }
        
       
      
            
            
        
    }
    
}
extension ApiService {
    
//        fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
//            return DataResponseSerializer { _, response, data, error in
//                guard error == nil else { return .failure(error!) }
//
//                guard let data = data else {
//                    return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
//                }
//
//                return Result { try JSONDecoder().decode(T.self, from: data) }
//            }
//        }
//
//        @discardableResult
//        fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
//            return responsePhoto(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
//        }
//
//        @discardableResult
//        func responsePhoto(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Photo>) -> Void) -> Self {
//            return responseDecodable(queue: queue, completionHandler: completionHandler)
//        }
    }

