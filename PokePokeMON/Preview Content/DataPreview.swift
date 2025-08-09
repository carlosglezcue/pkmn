//
//  DataPreview.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import Foundation

extension PokemonsModel {
    static let testModel = PokemonsModel(
        id: UUID(),
        name: "Bulbasur",
        image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
    )
}

extension PokemonDetailModel {
    static let testModel = PokemonDetailModel(
        id: 1,
        image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
        name: "Bulbasur",
        description: "BULBASAUR can be seen napping in\nbright sunlight.\nThere is a seed on its back.\nBy soaking up the sun’s rays, the seed\ngrows progressively larger.",
        baseExperience: 64,
        weight: 69,
        isBaby: true,
        isLegendary: false,
        isMythical: false,
        hasGenderDifferences: true,
        captureRate: "Hard",
        types: ["grass", "poison"],
        abilities: ["overgrow", "chlorophyll"],
        moves: ["razor-wind", "swords-dance", "cut", "bind", "vine-whip", "headbutt"],
        power: [45, 49, 49, 65, 65, 45],
        stats: ["hp", "attack", "defense", "special-attack", "special-defense", "speed"],
        growthRate: "medium-slow"
    )
}
