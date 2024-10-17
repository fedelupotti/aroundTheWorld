//
//  ContentView.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeViewModel = HomeViewModel(apiService: APIService())
    @State private var selectedSegment = 0
    
    var loadingOverlay: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
            .background(Color.white.opacity(0))
    }
    
    var segmentedControl: some View {
        Picker("", selection: $selectedSegment) {
            Text("All").tag(0)
            Text("Favorites").tag(1)
        }
        .pickerStyle(.segmented)
        .frame(width: 200)
        .padding(.bottom)
    }
    
    var dataSourceSelected: [City] {
        selectedSegment == 0 ? homeViewModel.citiesSearched : homeViewModel.citiesFavoritesSearched
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                segmentedControl
                
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(dataSourceSelected) { city in
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
            .searchable(text: $homeViewModel.searchableText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .environmentObject(homeViewModel)
    }
}

#Preview {
    ContentView()
}
