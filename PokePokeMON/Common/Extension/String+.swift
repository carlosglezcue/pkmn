//
//  String+.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import Foundation

extension String {
    var lastPathNumber: Int? {
        let trimmed = self.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let components = trimmed.split(separator: "/")
        return Int(components.last ?? "")
    }
}
