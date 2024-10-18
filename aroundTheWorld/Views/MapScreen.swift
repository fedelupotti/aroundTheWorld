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

    var body: some View {
        Map(position: $cameraPosition) {
            Marker(city?.name ?? "", coordinate: CLLocationCoordinate2D(latitude: city?.coordinate?.lat ?? Double(), longitude: city?.coordinate?.lon ?? Double()))
        }
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

#Preview {
    MapScreen(city: City.mock.first!)
}
