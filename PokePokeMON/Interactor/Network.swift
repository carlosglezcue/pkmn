//
//  Network.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import Foundation

protocol DataInteractor {
    func getList(items: Int) async throws -> [PokemonsModel]
    func getDetails(id: Int) async throws -> PokemonDetailModel
}

struct Network: DataInteractor, NetworkInteractor {
    static let shared = Network()
    
    func getList(items: Int) async throws -> [PokemonsModel] {
        let newListRequest = try await getJSON(request: .get(url: .getItems(limit: items) ), type: PokemonsList.self).results
        
        return getPokemonList(pokemons: newListRequest)
    }
    
    func getDetails(id: Int) async throws -> PokemonDetailModel {
        async let detailRequest = getJSON(request: .get(url: .getPokemonDetail(id: id)), type: PokemonDetails.self)
        async let speciesRequest = getJSON(request: .get(url: .getPokemonSpecies(id: id)), type: PokemonSpecies.self)
        
        let (details, species) = try await (detailRequest, speciesRequest)
        
        return getPokemonDetails(details: details, species: species)
    }
}

extension Network {
    
    func getPokemonList(pokemons: [Pokemons]) -> [PokemonsModel] {
        pokemons.map { pokemon in
            return pokemon.toPokemonsModel()
        }
    }
    
    func getPokemonDetails(details: PokemonDetails, species: PokemonSpecies) -> PokemonDetailModel {
        let types = details.types.map(\.type.name)
        let abilities = details.abilities.map(\.ability.name)
        let moves = details.moves.map(\.move.name)
        let power = details.stats.map(\.effort)
        let stats = details.stats.map(\.stat.name)
        
        return PokemonDetailModel(
            id: details.id,
            image: ApiConstants.getImageUrl(id: details.id),
            name: details.name,
            description: species.latestEnglishFlavorText ?? "",
            baseExperience: details.baseExperience ?? .zero,
            weight: details.weight,
            isBaby: species.isBaby,
            isLegendary: species.isLegendary,
            isMythical: species.isMythical,
            hasGenderDifferences: species.hasGenderDifferences,
            captureRate: species.captureDifficulty,
            types: types,
            abilities: abilities,
            moves: moves,
            power: power,
            stats: stats,
            growthRate: species.growthRate.name
        )
    }
}
