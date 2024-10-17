//
//  ContentView.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeViewModel = HomeViewModel(apiService: APIService())
    
    var loadingOverlay: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
            .background(Color.white.opacity(0))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(homeViewModel.citiesSearched) { city in
                        NavigationLink {
                            MapScreen(city: city)
                        } label: {
                            CityCellView(city: city)
                        }
                    }
                }
            }
            .overlay(alignment: .center) {
                if homeViewModel.isLoading {
                   loadingOverlay
                }
            }
            .navigationTitle("Arround the Word!")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $homeViewModel.searchableText)
        }
        .environmentObject(homeViewModel)
    }
}

#Preview {
    ContentView()
}
