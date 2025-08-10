//
//  PokeGridView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//

import SwiftUI

struct PokeGridView: View {
    
    let pokeList: [PokemonsModel]
    
    let adaptative: [GridItem] = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: adaptative, spacing: 20) {
                    ForEach(pokeList, id: \.self) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonCardGridView(name: pokemon.name.capitalized, image: pokemon.image)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .safeAreaPadding()
            .navigationTitle("Pokedex")
            .navigationDestination(for: PokemonsModel.self) { item in
                PokeDetailView(viewModel: PokeDetailViewModel(itemId: item.url.lastPathNumber ?? .zero))
            }
        }
    }
}

#Preview {
    PokeGridView(pokeList: [PokemonsModel.testModel])
}
