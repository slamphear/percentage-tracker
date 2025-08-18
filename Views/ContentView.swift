//
//  ContentView.swift
//  PercentageTracker
//
//  Created by Steven Lamphear on 8/8/25.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ListView(
                listModel: .init(
                    rows: []
                )
            )
        }
    }
}

#Preview {
    ContentView()
}
