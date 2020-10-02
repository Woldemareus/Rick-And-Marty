//
//  NetworkService.swift
//  Rick and Morty
//
//  Created by Vladimir Kholevin on 22.09.2020.
//  Copyright © 2020 Vladimir Kholevin. All rights reserved.
//


import UIKit

class NetworkService {

    // получение данных с сервера или из кэша (при наличии)
    public func networkRequest(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = URLCache.shared.cachedResponse(for: request)?.data {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } else {
                let dataTask = self.createDataTask(with: request, completion: completion)
                dataTask.resume()
            }
        }
    }
    
    // создание задачи для URLSession
    private func createDataTask(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let error = error as? URLError {
                print("error occured while retrieving data from Internet:", error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {return}
            self.saveDataToCache(data, request: request, response: response)
            DispatchQueue.main.async {
                completion(.success(data))
            }
        })
    }
    
    // сохранение данных в кэш
    private func saveDataToCache(_ data: Data, request: URLRequest, response: URLResponse?) {
        if let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300 {
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)
        }
    }
    
}
