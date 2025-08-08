//
//  LoadingView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 8/8/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        
        VStack {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.second)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow.opacity(0.4))
    }
}

#Preview {
    LoadingView()
}
