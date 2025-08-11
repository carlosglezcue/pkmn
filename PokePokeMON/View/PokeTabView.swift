//
//  PokeTabView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//

import SwiftUI

struct PokeTabView: View {
    
    @State var viewModel = PokeListViewModel()
    
    var body: some View {
        
        TabView {
            PokeListView(pokeList: viewModel.pokemonListSearched)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                        .foregroundStyle(.black)
                }
            
            PokeGridView(pokeList: viewModel.pokemonListSearched)
                .tabItem {
                    Label("Grid", systemImage: "circle.grid.2x2")
                }
        }
        .tint(.black)
        .navigationBarBackButtonHidden(true)
        .searchable(text: $viewModel.search, prompt: Text("Search Pokemon"))
        .fullScreenCover(isPresented: $viewModel.isStarting) {
            CardEnterView(
                sendAction: {
                    viewModel.checkNumberAdded(item: Int(viewModel.itemsToShow) ?? .zero)
                    if viewModel.isAllowed {
                        Task {await viewModel.getPokemonsList(items: Int(viewModel.itemsToShow) ?? .zero)}
                        viewModel.isStarting.toggle()
                    }
                },
                numberOfPokemons: $viewModel.itemsToShow,
                isAllowed: $viewModel.isAllowed
            )
        }
        .overlay {
            LoadingView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .alert("Alert!",
               isPresented: $viewModel.showAlert) {
            Button(role: .cancel) {
                viewModel.isStarting.toggle()
            } label: {
                Text("Cancel")
            }
            Button {
                Task {
                    await viewModel.getPokemonsList(items: Int(viewModel.itemsToShow) ?? .zero)
                }
            } label: {
                Text("Retry again")
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    PokeTabView()
}
