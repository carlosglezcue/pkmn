//
//  PokemonCardGridView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//

import SwiftUI

struct PokemonCardGridView: View {
    
    let name: String
    let image: String
    
    let fixedItems: [GridItem] = [GridItem(.fixed(230)), GridItem(.fixed(230))]
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.main.opacity(0.5))
            
            VStack {
                
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
                
                HStack {
                    Text(name)
                        .font(.body)
                        .bold()
                        .foregroundStyle(.mainText)
                    
                    Image(systemName: "chevron.right.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.second)
                }
                .padding(.top)
            }
            .padding()
        }
    }
}

#Preview {
    PokemonCardGridView(
        name: PokemonsModel.testModel.name,
        image: PokemonsModel.testModel.image
    )
}
