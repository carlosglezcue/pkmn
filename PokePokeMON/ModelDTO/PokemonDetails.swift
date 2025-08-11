//
//  PokemonDetails.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import Foundation

// MARK: - Pokemon details Model

struct PokemonDetails: Codable {
    let id: Int
    let name: String
    let baseExperience: Int?
    let weight: Int
    let abilities: [PokemonAbility]
    let types: [PokemonType]
    let sprites: PokemonSprites
    let stats: [PokemonStat]
    let moves: [PokemonMove]
    
    enum CodingKeys: String, CodingKey {
        case id, name, weight, abilities, types, sprites, stats, moves
        case baseExperience = "base_experience"
    }
}

// MARK: - Pokemon Ability

struct PokemonAbility: Codable {
    let isHidden: Bool
    let slot: Int
    let ability: Reference
    
    enum CodingKeys: String, CodingKey {
        case slot, ability
        case isHidden = "is_hidden"
    }
}

// MARK: - Pokemon Type

struct PokemonType: Codable {
    let slot: Int
    let type: Reference
}

// MARK: - Pokemon Sprites

struct PokemonSprites: Codable {
    let frontDefault: String?
    let frontShiny: String?
    let backDefault: String?
    let backShiny: String?
    let other: OtherSprites?
    
    enum CodingKeys: String, CodingKey {
        case other
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
    }
}

struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork?
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String?
    let frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

// MARK: - Pokemon Stats

struct PokemonStat: Codable {
    let baseStat: Int
    let effort: Int
    let stat: Reference
    
    enum CodingKeys: String, CodingKey {
        case effort, stat
        case baseStat = "base_stat"
    }
}

// MARK: - Pokemon Moves

struct PokemonMove: Codable {
    let move: Reference
    let versionGroupDetails: [VersionGroupDetail]
    
    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

struct VersionGroupDetail: Codable {
    let levelLearnedAt: Int
    let versionGroup: Reference
    let moveLearnMethod: Reference
    
    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case versionGroup = "version_group"
        case moveLearnMethod = "move_learn_method"
    }
}

struct Reference: Codable {
    let name: String
    let url: String
}
