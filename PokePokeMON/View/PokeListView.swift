//
//  PokeListView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import SwiftUI

struct PokeListView: View {
    
    @State var allowedNumber: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.main.opacity(0.7))
        .overlay {
            CardEnterView(
                sendAction: {  },
                numberOfPokemons: "",
                isAllowed: allowedNumber,
                isVisible: true
            )
        }
    }
}

#Preview {
    PokeListView()
}
