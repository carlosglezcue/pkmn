//
//  PokemonFormDetailView.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//

import SwiftUI

struct PokemonFormDetailView: View {
    
    let detailModel: PokemonDetailModel
    
    var body: some View {
        Form {
            Section {
                LabeledContent("Type:", value: detailModel.types.first?.capitalized ?? "-")
                LabeledContent("Weight:", value: "\(detailModel.weight) kg")
                LabeledContent("Growth rate:", value: detailModel.growthRate.capitalized)
                LabeledContent("Capture rate:", value: detailModel.captureRate)
                LabeledContent("Base experience:", value: "\(detailModel.baseExperience) pt")
                LabeledContent("Pokemon Legendary:", value: detailModel.isLegendary ? "✅" : "-")
            }
            .font(.body)
            
            Section {
                DisclosureGroup {
                    ForEach(Array(zip(detailModel.stats, detailModel.power)), id: \.0) { name, point in
                        LabeledContent("\(name.uppercased()):", value: "\(point) pt")
                            .font(.caption)
                            .foregroundStyle(.mainText)
                    }
                } label: {
                    Text("Stats")
                        .font(.body)
                        .bold()
                        .foregroundStyle(.second)
                }
                
                DisclosureGroup {
                    ForEach(detailModel.moves, id: \.self) { move in
                        Text(move.capitalized)
                            .font(.caption)
                            .foregroundStyle(.mainText)
                    }
                } label: {
                    Text("Moves")
                        .font(.body)
                        .bold()
                        .foregroundStyle(.second)
                }
            }
        }
    }
}
