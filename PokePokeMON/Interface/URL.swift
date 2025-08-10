//
//  URL.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import Foundation

enum ApiConstants {
    static let api = URL(string: "https://pokeapi.co/api/v2/")!
    
    static func getImageUrl(id: Int) -> String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
}

extension URL {
    
    static func getItems(limit: Int) -> URL {
        ApiConstants.api.appending(path: "pokemon")
            .appending(queryItems: [.setLimitItems(for: limit)])
    }
    
    static func getPokemonDetail(id: Int) -> URL {
        ApiConstants.api.appending(path: "pokemon")
            .appending(path: "\(id)")
    }
    
    static func getPokemonSpecies(id: Int) -> URL {
        ApiConstants.api.appending(path: "pokemon-species")
            .appending(path: "\(id)")
    }
}

extension URLQueryItem {
    static func setLimitItems(for limit: Int) -> URLQueryItem {
        URLQueryItem(name: "limit", value: "\(limit)")
    }
}
