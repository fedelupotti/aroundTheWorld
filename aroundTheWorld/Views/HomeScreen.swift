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
        NavigationStack {
            List {
                ForEach(homeViewModel.serachableCities) { city in
                    VStack(alignment: .leading) {
                        
                        HStack(alignment: .center) {
                            Text(city.name ?? "")
                            Text(city.country ?? "")
                        }
                        .font(.title2.bold())
                        
                        HStack(alignment: .center) {
                            Text("Lat: \(city.coordinate?.lat ?? Float())")
                            Text("Lon: \(city.coordinate?.lon ?? Float())")
                        }
                        .font(.callout)
                        .padding(.top, 2)
                    }
                }
            }
            .navigationTitle("Arround the Word!")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $homeViewModel.searchableText)
        }
        
    }
}

#Preview {
    ContentView()
}
