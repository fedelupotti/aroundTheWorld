//
//  ContentView.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Orientation var orientationDevice
    
    @StateObject var homeViewModel = HomeViewModel(apiService: APIService())
    
    @State private var citySelected: City?
    @State private var selectedSegment = 0
        
    private let navitationTitle = "Around the World!"
    
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
        Group {
            if orientationDevice.isPortrait {
                verticalView
            } else {
                horizontalView
            }
        }
        .environmentObject(homeViewModel)
        .onAppear(perform: {
            homeViewModel.fetchCities()
        })
        
    }
    
    private var verticalView: some View {
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
            .navigationTitle(navitationTitle)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $homeViewModel.searchableText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
    
    private var horizontalView: some View {
        HStack(spacing: 0) {
            NavigationStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(dataSourceSelected) { city in
                            CityCellView(city: city)
                                .onTapGesture {
                                    print("City Changed")
                                    citySelected = city
                                }
                        }
                    }
                }
                .navigationTitle(navitationTitle)
                .searchable(text: $homeViewModel.searchableText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.4)
            
            MapScreen(city: citySelected)
                .frame(maxWidth: .infinity)
        }
        .overlay(alignment: .center) {
            if homeViewModel.isLoading {
                loadingOverlay
            }
        }
    }
    
}

#Preview {
    ContentView()
}
