//
//  PokePokeMONApp.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import SwiftUI

@main
struct PokePokeMONApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            PokeTabView()
                .overlay {
                    if scenePhase != .active {
                        SplashView()
                    }
                }
        }
    }
}
