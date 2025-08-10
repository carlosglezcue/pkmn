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
            ScrollView(showsIndicators: false) {
                LazyVStack() {
                    ForEach(pokeList, id: \.self) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonCardListView(name: pokemon.name.capitalized, image: pokemon.image)
                        }
                    }
                }
            }
            .navigationTitle("Pokedex")
            .navigationDestination(for: PokemonsModel.self) { item in
                PokeDetailView(viewModel: PokeDetailViewModel(itemId: item.url.lastPathNumber ?? .zero))
            }
        }
    }
}

#Preview {
    PokeListView(pokeList: [PokemonsModel.testModel])
}
