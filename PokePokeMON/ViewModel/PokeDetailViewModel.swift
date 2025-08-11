//
//  PokeDetailViewModel.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import Foundation

@Observable
final class PokeDetailViewModel {
    
    // MARK: - Properties
    
    var errorMessage: String = ""
    var showAlert: Bool = false
    var isLoading: Bool = false
    var itemId: Int
    var details: PokemonDetailModel?
    
    let interactor: DataInteractor
    
    init(interactor: DataInteractor = Network.shared, itemId: Int) {
        self.interactor = interactor
        self.itemId = itemId
    }
    
    // MARK: - Functions
    
    func getPokemonsDetails(id: Int) async {
        isLoading = true
        do {
            let item = try await interactor.getDetails(id: id)
            await loadData(item: item)
            isLoading = false
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showAlert.toggle()
                isLoading = false
            }
        }
    }
    
    @MainActor func loadData(item: PokemonDetailModel) async {
        details = item
    }
}
