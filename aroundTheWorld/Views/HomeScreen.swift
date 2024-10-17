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
                            
                            HStack(alignment: .center) {
                                
                                Toggle("", isOn: Binding(
                                    get: { city.isFavorite ?? false },
                                    set: { newValue in
                                        homeViewModel.updateCity(city, isFavorite: newValue)
                                    })
                                )
                                .toggleStyle(.city)
                                .padding([.leading, .trailing], 10)
                                
                                VStack(alignment: .leading) {
                                    
                                    HStack(alignment: .center) {
                                        Text(city.name ?? "")
                                        Text(city.country ?? "")
                                    }
                                    .font(.title2.bold())
                                    .foregroundStyle(Color.primary)
                                    
                                    HStack(alignment: .center) {
                                        Text("Lat: \(city.coordinate?.lat ?? Double())")
                                        Text("Lon: \(city.coordinate?.lon ?? Double())")
                                    }
                                    .font(.callout)
                                    .foregroundStyle(Color.primary)
                                    .padding(.top, 2)
                                }
                            }
                            
                            
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
        
    }
}

#Preview {
    ContentView()
}
