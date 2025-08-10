//
//  PrincipalImageView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//

import SwiftUI

struct PrincipalImageView: View {
    
    let image: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 200, height: 200)
                .foregroundStyle(.second)
            
            AsyncImage(url: URL(string: image)) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                            .tint(.main)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
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
        }
    }
}

#Preview {
    PrincipalImageView(image: PokemonDetailModel.testModel.image)
}
