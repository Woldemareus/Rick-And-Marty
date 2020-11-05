//
//  NetworkDataFetcher.swift
//  Rick and Morty
//
//  Created by Vladimir Kholevin on 27.09.2020.
//  Copyright © 2020 Vladimir Kholevin. All rights reserved.
//

import UIKit

class NetworkFetcher {    
    
    private let networkService = NetworkService()
    
    /// Парсим в модель
    private func decodeData<T:Decodable>(_ data: Data, toModelType: T.Type) -> T? {
        
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            print("error occured while parsing JSON:", error)
            return nil
        }
    }
    
    /// Достаем объект модели по URL
    public func fetchModelObject<T:Decodable>(urlString: String, completion: @escaping (Result<T?, Error>) -> Void) {
        
        networkService.networkRequest(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                let searchResult = self.decodeData(data, toModelType: T.self)
                completion(.success(searchResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Достаем рисунок по URL
    public func fetchImage(urlString: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        
        networkService.networkRequest(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
 
}
