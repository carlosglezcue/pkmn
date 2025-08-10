//
//  PokemonDetailHeaderView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//

import SwiftUI

struct PokemonDetailHeaderView: View {
    
    let detailModel: PokemonDetailModel
    
    var body: some View {
        VStack {
            BackButton()
            
            HStack {
                Text("\(detailModel.id). \(detailModel.name.uppercased())")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            
            PrincipalImageView(image: detailModel.image)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0.0, y: 10)
            
            Text(detailModel.description)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
                .foregroundColor(.mainText)
                .padding()
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.main.opacity(0.8))
    }
}

#Preview {
    PokemonDetailHeaderView(
        detailModel: PokemonDetailModel.testModel
    )
}
