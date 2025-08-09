//
//  PokemonsModel.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import Foundation

struct PokemonsModel: Identifiable, Hashable {
    let id: UUID
    let name: String
    let image: String
}
