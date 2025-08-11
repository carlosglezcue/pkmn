//
//  PokeListViewModel.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import Foundation

@Observable
final class PokeListViewModel {
    
    // MARK: - Properties
    
    var itemsToShow: String = ""
    var errorMessage: String = ""
    var search = ""
    var showAlert: Bool = false
    var isLoading: Bool = false
    var isAllowed: Bool = true
    var isStarting: Bool = true
    var pokemonsList: [PokemonsModel] = []
    var pokemonListSearched: [PokemonsModel] {
        let searchFilter = pokemonsList.filter { pokemon in
            if search.isEmpty {
                true
            } else {
                pokemon.name.localizedStandardContains(search)
            }
        }
        return searchFilter
    }
    
    let interactor: DataInteractor
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    // MARK: - Functions
    
    func getPokemonsList(items: Int) async {
        isLoading = true
        do {
            let list = try await interactor.getList(items: items)
            await loadData(list: list)
            isLoading = false
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showAlert.toggle()
                isLoading = false
            }
        }
    }
    
    @MainActor func loadData(list: [PokemonsModel]) async {
        pokemonsList = list
    }
    
    func checkNumberAdded(item: Int) {
        let noItems = 0
        let maximumItems = 1302
        
        isAllowed = item > noItems && item <= maximumItems
    }
}
