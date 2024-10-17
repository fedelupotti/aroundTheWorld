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
                            
                            VStack(alignment: .leading) {
                                
                                HStack(alignment: .center) {
                                    Text(city.name ?? "")
                                    Text(city.country ?? "")
                                }
                                .font(.title2.bold())
                                
                                HStack(alignment: .center) {
                                    Text("Lat: \(city.coordinate?.lat ?? Double())")
                                    Text("Lon: \(city.coordinate?.lon ?? Double())")
                                }
                                .font(.callout)
                                .padding(.top, 2)
                            }
                        }
                        

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
