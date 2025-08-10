//
//  PokemonDetailModel.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import Foundation

struct PokemonDetailModel: Identifiable, Hashable {
    let id: Int
    let image: String
    let name: String
    let description: String
    let baseExperience: Int
    let weight: Int
    let isBaby: Bool
    let isLegendary: Bool
    let isMythical: Bool
    let hasGenderDifferences: Bool
    let captureRate: String
    let types: [String]
    let moves: [String]
    let power: [Int]
    let stats: [String]
    let growthRate: String
}
