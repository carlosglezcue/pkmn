//
//  PokeListView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import SwiftUI

struct PokeListView: View {
    
    let pokeList: [PokemonsModel]
    
    var body: some View {
        NavigationStack {
            LazyVStack() {
                ForEach(pokeList, id: \.self) { pokemon in
                    NavigationLink(value: pokemon) {
                        PokemonCardListView(name: pokemon.name, image: pokemon.image)
                    }
                }
            }
            .navigationTitle("Pokedex")
            .navigationDestination(for: PokemonsModel.self) { pokemon in
                PokeDetailView(detailModel: PokemonDetailModel.testModel)
            }
        }
    }
}

#Preview {
    PokeListView(pokeList: [PokemonsModel.testModel])
}
