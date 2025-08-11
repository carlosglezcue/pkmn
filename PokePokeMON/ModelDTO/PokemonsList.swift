//
//  PokemonsList.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import Foundation

struct PokemonsList: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Pokemons]
}

struct Pokemons: Codable {
    let name: String
    let url: String
}

extension Pokemons {
    func toPokemonsModel() -> PokemonsModel {
        PokemonsModel(
            id: UUID(),
            name: name,
            image: ApiConstants.getImageUrl(id: url.lastPathNumber ?? .zero),
            url: url
        )
    }
}
