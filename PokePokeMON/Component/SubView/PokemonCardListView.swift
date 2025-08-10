//
//  PokemonCardListView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import SwiftUI

struct PokemonCardListView: View {
    
    let name: String
    let image: String
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 150)
                .foregroundStyle(.main.opacity(0.5))
            
            HStack {
                
                AsyncImage(url: URL(string: image)) { phase in
                    switch phase {
                        case .empty:
                            ProgressView()
                                .tint(.second)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        case .failure:
                            Image(systemName: "document")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.trailing)
                                .shadow(radius: 8)
                        @unknown default:
                            EmptyView()
                    }
                }
                
                Text(name)
                    .font(.body)
                    .bold()
                    .foregroundStyle(.mainText)
                    .padding(.leading)
                
                Spacer()
                
                Image(systemName: "chevron.right.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.second)
            }
            .padding(.horizontal, 30)
        }
        .padding(.horizontal)
    }
}

#Preview {
    PokemonCardListView(
        name: PokemonsModel.testModel.name,
        image: PokemonsModel.testModel.image
    )
}
