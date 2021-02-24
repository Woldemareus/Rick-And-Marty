//
//  CharacterFetcher.swift
//  Rick and Morty
//
//  Created by Vladimir Kholevin on 27.09.2020.
//  Copyright © 2020 Vladimir Kholevin. All rights reserved.
//

import UIKit

public protocol ICharacterFetcher {
    func fetchCharacters(page: Int, completion: @escaping (Result<CharactersRequest?, Error>) -> Void)
    func fetchCharacterImage(urlString: String, completion: @escaping ((Result<UIImage?,Error>) -> Void))
}

public class CharacterFetcher: ICharacterFetcher {
    
    let networkFetcher: INetworkFetcher
    
    // MARK: - Initialization
    
    public init() {
        self.networkFetcher = NetworkFetcher()
    }
    
    // MARK: - Public methods
    
    /// Получаем персонажей по запросу к API
    public func fetchCharacters(page: Int, completion: @escaping (Result<CharactersRequest?, Error>) -> Void) {
        
        let urlString = "https://rickandmortyapi.com/api/character/?page=\(page)"
        networkFetcher.fetchModelObject(urlString: urlString, completion: completion)
    }
    
    /// Получаем аватарку персонажа по URL
    public func fetchCharacterImage(urlString: String, completion: @escaping ((Result<UIImage?,Error>) -> Void)) {
        
        networkFetcher.fetchImage(urlString: urlString, completion: completion)
    }
    
}
