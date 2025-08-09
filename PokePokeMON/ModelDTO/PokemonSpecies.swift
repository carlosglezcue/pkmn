//
//  PokemonSpecies.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import Foundation

// MARK: - Main Pokemon Species Model

struct PokemonSpecies: Codable {
    let id: Int
    let name: String
    let captureRate: Int
    let isBaby: Bool
    let isLegendary: Bool
    let isMythical: Bool
    let hasGenderDifferences: Bool
    let growthRate: Reference
    let flavorTextEntries: [FlavorTextEntry]
    
    enum CodingKeys: String, CodingKey {
        case id, name 
        case captureRate = "capture_rate"
        case isBaby = "is_baby"
        case isLegendary = "is_legendary"
        case isMythical = "is_mythical"
        case hasGenderDifferences = "has_gender_differences"
        case growthRate = "growth_rate"
        case flavorTextEntries = "flavor_text_entries"
    }
}

struct FlavorTextEntry: Codable {
    let flavorText: String
    let language: Reference
    let version: Reference
    
    enum CodingKeys: String, CodingKey {
        case language, version
        case flavorText = "flavor_text"
    }
}

// MARK: - Helper Extensions for UI
extension PokemonSpecies {
    
    /// Get the latest English flavor text
    var latestEnglishFlavorText: String? {
        return flavorTextEntries.first { $0.language.name == "en" }?.flavorText
    }
    
    /// Format capture rate as difficulty description
    var captureDifficulty: String {
        switch captureRate {
        case 0...29: return "Very Hard"
        case 30...89: return "Hard"
        case 90...149: return "Medium"
        case 150...199: return "Easy"
        default: return "Very Easy"
        }
    }
}
