//
//  CityDetailSheetScreen.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 21/10/24.
//

import SwiftUI

struct CityDetailSheetScreen: View {
    var city: City
    @Environment(\.dismiss) var dismiss
    
    private func closeSheet() {
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("City: \(city.name ?? "N/A")")
                    .font(.title)
                
                Text("Country: \(city.country ?? "N/A")")
                    .font(.subheadline)
                    .padding(.top, 5)
                
                Text("Coordinates: \(city.coordinate?.lat ?? 0), \(city.coordinate?.lon ?? 0)")
                    .font(.subheadline)
                    .padding(.top, 1)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: closeSheet, label: {
                        Image(systemName: "xmark.circle.fill")
                            .scaledToFit()
                            .foregroundStyle(.gray.opacity(0.8))
                    })
                })
            }
        }
    }
}

#Preview {
    CityDetailSheetScreen(city: City.mock.first!)
}
