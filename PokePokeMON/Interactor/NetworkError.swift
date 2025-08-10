//
//  NetworkError.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import Foundation

public enum NetworkError: LocalizedError {
    case general(Error)
    case status(Int)
    case json(Error)
    case dataNotValid
    case nonHTTP
    
    public var errorDescription: String? {
        switch self {
            case .general(let error):
                "General Error: \(error.localizedDescription)"
            case .status(let int):
                "Status Error: \(int)."
            case .json(let error):
                "JSON Error: \(error)."
            case .dataNotValid:
                "Error, data not valid."
            case .nonHTTP:
                "It's not an HTTP connection."
        }
    }
}
