//
//  MapScreen.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    @State var city: City
    
    var body: some View {
        Map(initialPosition: MapCameraPosition.automatic) {
            Marker(city.name ?? "", coordinate: CLLocationCoordinate2D(latitude: city.coordinate?.lat ?? Double(), longitude: city.coordinate?.lon ?? Double()))
        }
    }
}

#Preview {
    MapScreen(city: City.mock.first!)
}
