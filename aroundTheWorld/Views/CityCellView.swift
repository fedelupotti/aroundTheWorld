//
//  CityCellView.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 17/10/24.
//

import SwiftUI

struct CityCellView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var city: City
    
    @ViewBuilder
    func toggleView(for city: City) -> some View {
        Toggle("", isOn: Binding(
            get: { city.isFavorite ?? false },
            set: { newValue in
                homeViewModel.updateCity(city, isFavorite: newValue)
            })
        )
        .toggleStyle(.city)
        .padding([.leading, .trailing], 10)
    }
    
    @ViewBuilder
    func titlesView(for city: City) -> some View {
        HStack(alignment: .center) {
            Text(city.name ?? "")
            Text(city.country ?? "")
        }
        .font(.title2.bold())
    }
    
    @ViewBuilder
    func coordinatesView(for city: City) -> some View {
        HStack(alignment: .center) {
            Text("Lat: \(city.coordinate?.lat ?? Double())")
            Text("Lon: \(city.coordinate?.lon ?? Double())")
        }
        .font(.callout)
        .padding(.top, 2)
    }
    var body: some View {
        HStack(alignment: .center) {
            toggleView(for: city)
            
            VStack(alignment: .leading) {
                titlesView(for: city)
                coordinatesView(for: city)
            }
            .foregroundStyle(Color.primary)
            
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    CityCellView(city: City.mock.first!)
}
