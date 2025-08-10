//
//  PokeDetailView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import SwiftUI

struct PokeDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel: PokeDetailViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            if let details = viewModel.details {
                ScrollView(showsIndicators: false) {
                    PokemonDetailHeaderView(detailModel: details)
                    PokemonFormDetailView(detailModel: details)
                }
            } else {
                ErrorDetailView(errorMessage: viewModel.errorMessage)
            }
        }
        .overlay {
            LoadingView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .alert("Alert!",
               isPresented: $viewModel.showAlert) {
            Button(role: .cancel) {
                dismiss()
            } label: {
                Text("Cancel")
            }
            Button {
                Task {
                    await viewModel.getPokemonsDetails(id: viewModel.itemId)
                }
            } label: {
                Text("Retry again")
            }
        } message: {
            Text(viewModel.errorMessage)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await viewModel.getPokemonsDetails(id: viewModel.itemId)
            }
        }
    }
}

#Preview {
    PokeDetailView(viewModel: PokeDetailViewModel(itemId: 1))
}
