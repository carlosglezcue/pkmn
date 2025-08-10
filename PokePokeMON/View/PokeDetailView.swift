//
//  PokeDetailView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import SwiftUI

struct PokeDetailView: View {
    
    let detailModel: PokemonDetailModel
    
    var body: some View {
        VStack(spacing: .zero) {
            PokemonDetailHeaderView(detailModel: detailModel)
            PokemonFormDetailView(detailModel: detailModel)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PokeDetailView(detailModel: PokemonDetailModel.testModel)
}
