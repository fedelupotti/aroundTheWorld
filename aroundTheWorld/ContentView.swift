//
//  ContentView.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeViewModel = HomeViewModel(apiService: APIService())
    var body: some View {
        List {
            ForEach(homeViewModel.cities) { city in
                Text(city.name ?? "")
            }
        }
    }
}

#Preview {
    ContentView()
}
