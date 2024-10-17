//
//  CityToggleStyle.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 17/10/24.
//

import SwiftUI

struct CityToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "star.fill" : "star")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(configuration.isOn ? .yellow : .gray)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

extension ToggleStyle where Self == CityToggleStyle {
    static var city: CityToggleStyle {
        CityToggleStyle()
    }
}
