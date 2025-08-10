//
//  PokeTabView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//

import SwiftUI

struct PokeTabView: View {
    
    @State var isStarting: Bool = true
    
    var body: some View {
        
        TabView {
            PokeListView(pokeList: [PokemonsModel.testModel])
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                        .foregroundStyle(.black)
                }
            
            PokeGridView(pokeList: [PokemonsModel.testModel])
                .tabItem {
                    Label("Grid", systemImage: "circle.grid.2x2")
                }
        }
        .tint(.black)
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isStarting) {
            CardEnterView(
                sendAction: { isStarting.toggle() },
                numberOfPokemons: "",
                isAllowed: false
            )
        }
    }
}

#Preview {
    PokeTabView()
}
