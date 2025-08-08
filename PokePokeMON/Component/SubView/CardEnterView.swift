//
//  CardEnterView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 7/8/25.
//

import SwiftUI

struct CardEnterView: View {
    
    let sendAction: () -> ()
    
    @State var numberOfPokemons: String
    @State var isAllowed: Bool
    @State var isVisible: Bool = true
    
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        
        ZStack(alignment: .center) {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.main)
                .frame(height: 450)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 1)
                )
            
            VStack(alignment: .leading) {
                
                Text("Welcome to your new Pokedex")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.black)
                
                Text("Here, you can find the best information about your favorite Pokemons.")
                    .font(.subheadline)
                    .foregroundStyle(.mainText)
                
                Text("Please, enter the number of pokemons you want to see this time:")
                    .font(.body)
                    .bold()
                    .foregroundStyle(.mainText)
                    .padding(.top, 50)
                
                HStack(alignment: .firstTextBaseline, spacing: 50) {
                    
                    VStack(alignment: .leading) {
                        
                        TextField("Enter number", text: $numberOfPokemons)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .font(.body)
                        
                        if isAllowed {
                            Text("The number entered is greater than 150")
                                .font(.caption2)
                                .foregroundStyle(.third)
                                .padding(.leading, 3)
                                .padding(.bottom, 5)
                        }
                        
                        Text("Maximum number allowed 1302")
                            .font(.caption2)
                            .foregroundStyle(.mainText.opacity(0.5))
                            .padding(.leading, 3)
                    }
                    
                    Button {
                        isVisible.toggle()
                    } label: {
                        Text("Send")
                            .font(.body)
                            .bold()
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.second)
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 30)
        }
        .rotationEffect(.degrees(rotationAngle))
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5)) {
                rotationAngle = 360
            }
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .padding()
    }
}

#Preview {
    CardEnterView(
        sendAction: { },
        numberOfPokemons: "",
        isAllowed: false
    )
}
