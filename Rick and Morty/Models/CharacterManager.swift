//
//  CharacterManager.swift
//  Rick and Morty
//
//  Created by Vladimir Kholevin on 22.09.2020.
//  Copyright © 2020 Vladimir Kholevin. All rights reserved.
//

import UIKit

public protocol ICharacterManager {
    var characters: [Character] {get}
    var characterImages: [Int:UIImage?] {get}
    var isFetchingData: Bool {get}
    var nextPageIsNull: Bool {get}
    
    func fetchCharacters(completion: @escaping (Error?) -> Void)
    func fetchCharacterImages(newCharacters: [Character], oldCharacters: [Character], completion: @escaping (Error?) -> Void)
}

public class CharacterManager: ICharacterManager {
    
    public var characters: [Character] = []
    public var characterImages: [Int:UIImage?] = [:]
    public var isFetchingData = false
    public var nextPageIsNull = false
    
    let characterFetcher: ICharacterFetcher
    
    let numberOfItemsToFetch = 20 // фиксированное число результатов на странице
    var nextPageToLoad: Int = 1
    
    // MARK: - Initialization
    
    public init() {
        self.characterFetcher = CharacterFetcher()
    }
    
    // MARK: - Public methods
    
    /// Достаем персонажей
    public func fetchCharacters(completion: @escaping (Error?) -> Void) {
        
        isFetchingData = true
        characterFetcher.fetchCharacters(page: nextPageToLoad, completion: { [weak self] result in
            guard let self = self else {return}
            
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
        
        newCharacters.enumerated().forEach { [weak self] (index, character) in
            guard let self = self else {return}
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
