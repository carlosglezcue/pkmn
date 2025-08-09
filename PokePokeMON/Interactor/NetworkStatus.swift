//
//  NetworkStatus.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 9/8/25.
//

import SwiftUI
import Network

@Observable
public final class NetworkStatus {
    public enum Status {
        case offline, online, unknown
    }
    
    public var status = Status.online
    
    let monitor = NWPathMonitor()
    @ObservationIgnored var queue = DispatchQueue(label: "MonitorNetwork")
    
    init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [self] path in
            DispatchQueue.main.async {
                self.status = path.status != .unsatisfied ? .online : .offline
            }
        }
    }
}
