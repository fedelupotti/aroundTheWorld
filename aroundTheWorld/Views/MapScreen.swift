//
//  MapScreen.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    var city: City?
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var isPresentingDetails = false
    
    private func showDetails() {
        isPresentingDetails.toggle()
    }
    
    var body: some View {
        NavigationStack {
            Map(position: $cameraPosition) {
                Marker(city?.name ?? "", coordinate: CLLocationCoordinate2D(latitude: city?.coordinate?.lat ?? Double(), longitude: city?.coordinate?.lon ?? Double()))
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom, content: {
                Button(action: showDetails, label: {
                    Text("Show details")
                        .bold()
                        .foregroundStyle(Color.secondary)
                    
                })
                .padding(8)
                .background(Color.blue, in: RoundedRectangle(cornerRadius: 10))
            })
            .sheet(isPresented: $isPresentingDetails, content: {
                if let city {
                    CityDetailSheetScreen(city: city)            .presentationDetents([.fraction(1/4)])
                        .presentationCornerRadius(20)
                }
            })
            .onChange(of: (city?.id) ?? nil) { _ , _ in
                if let city, let lat = city.coordinate?.lat, let lon = city.coordinate?.lon {
                    withAnimation(.easeInOut(duration: 2)) {
                        cameraPosition = .region(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: lat,
                                longitude: lon
                            ),
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.8,
                                longitudeDelta: 0.8
                            ))
                        )
                    }
                    
                }
            }
        }
    }
}

#Preview {
    MapScreen(city: City.mock.first!)
}
