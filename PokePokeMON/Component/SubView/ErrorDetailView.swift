//
//  ErrorDetailView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//

import SwiftUI

struct ErrorDetailView: View {
    
    let errorMessage: String
    
    var body: some View {
        VStack(spacing: 50) {
            Image(systemName: "exclamationmark.bubble.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .foregroundStyle(.third)
            
            Text(errorMessage)
                .font(.title3)
                .bold()
                .foregroundStyle(.third)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.third.opacity(0.3))
    }
}

#Preview {
    ErrorDetailView(errorMessage: "Error Message")
}
