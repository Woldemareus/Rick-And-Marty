//
//  CharacterManager.swift
//  Rick and Morty
//
//  Created by Vladimir Kholevin on 22.09.2020.
//  Copyright © 2020 Vladimir Kholevin. All rights reserved.
//

import UIKit

class CharacterManager {
    
    let characterFetcher = CharacterFetcher()
    
    var characters: [Character] = []
    var characterImages: [Int:UIImage?] = [:]
    
    let numberOfItemsToFetch = 20 // фиксированное число результатов на странице
    var nextPageToLoad: Int = 1
    var nextPageIsNull = false
    
    var isFetchingData = false
    
    /// Достаем персонажей
    public func fetchCharacters(completion: @escaping (Error?) -> Void) {
        
        isFetchingData = true
        characterFetcher.fetchCharacters(page: nextPageToLoad, completion: { (result) in
                        
            switch result {
            case .success(let searchResult):
                guard let searchResult = searchResult else { return }
                guard let newCharacters = searchResult.results else { return }
                
                // проверка - последняя ли это страница
                if let info = searchResult.info, info.next == nil {
                    self.nextPageIsNull = true
                }
                
                let oldCharacters = self.characters
                self.characters += newCharacters
                self.nextPageToLoad += 1
                completion(nil)
                self.isFetchingData = false
                
                // достаем аватарки
                self.fetchCharacterImages(newCharacters: newCharacters, oldCharacters: oldCharacters) { error in
                    completion(nil)
                }
                
            case .failure(let error):
                completion(error)
                self.isFetchingData = false
            }
        })
    }
    
    /// Достаем иконки для полученных ранее персонажей
    public func fetchCharacterImages(newCharacters: [Character], oldCharacters: [Character], completion: @escaping (Error?) -> Void) {
        
        newCharacters.enumerated().forEach { (index, character) in
            guard let imageUrl = character.image else {return}
            
            self.characterFetcher.fetchCharacterImage(urlString: imageUrl, completion: { result in
                switch result {
                case .success(let image):
                    let actualKey = index + oldCharacters.count
                    self.characterImages[actualKey] = image
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
                
            })
        }
    }
}
