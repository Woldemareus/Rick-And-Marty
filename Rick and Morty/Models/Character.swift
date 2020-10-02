//
//  Character.swift
//  Rick and Morty
//
//  Created by Vladimir Kholevin on 22.09.2020.
//  Copyright © 2020 Vladimir Kholevin. All rights reserved.
//

import Foundation

struct CharactersRequest: Decodable {
    var results: [Character]?
    var info: Info?
}

struct Info: Decodable {
    var next: String?
}

struct Character: Decodable {
    var name: String?
    var image: String?
}
