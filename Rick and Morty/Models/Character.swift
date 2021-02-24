//
//  Character.swift
//  Rick and Morty
//
//  Created by Vladimir Kholevin on 22.09.2020.
//  Copyright © 2020 Vladimir Kholevin. All rights reserved.
//

import Foundation

public struct CharactersRequest: Decodable {
    var results: [Character]?
    var info: Info?
}

public struct Character: Decodable {
    var name: String?
    var image: String?
}

public struct Info: Decodable {
    var next: String?
}


