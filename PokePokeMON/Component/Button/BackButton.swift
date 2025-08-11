//
//  BackButton.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//

import SwiftUI

struct BackButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.second)
                    .frame(width: 30, height: 30)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
