//
//  WifiView.swift
//  Parkaroo
//
//  Created by max rome on 6/4/21.
//

import Foundation
import Network
import SwiftUI

final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published var isConnected = true
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
}
struct WifiView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "wifi.slash")
                Text("Not Connected")
            }.padding()
            .background(Color("orange1"))
            .cornerRadius(50)
            .padding(.top)
            Spacer()
        }
    }
}
struct WifiView_Previews: PreviewProvider {
    static var previews: some View {
        WifiView()
    }
}
