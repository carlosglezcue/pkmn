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
    var showAlert: Bool = false
    var isLoading: Bool = false
    var isAllowed: Bool = false
    var isStarting: Bool = true
    var pokemonsList: [PokemonsModel] = []
    
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
}
