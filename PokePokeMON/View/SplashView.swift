//
//  SplashView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 8/8/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        
        VStack {
            
            Text("PokePokeMON")
                .font(.largeTitle)
                .foregroundStyle(.mainText)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.main)
    }
}

#Preview {
    SplashView()
}
