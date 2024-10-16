//
//  City.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//

import Foundation

struct City: Decodable, Identifiable {
    let country: String?
    let name: String?
    let id: Int?
    let coordinate: Coordinate?
    
    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coordinate = "coord"
    }
}

struct Coordinate: Decodable {
    let lon: Float?
    let lat: Float?
}
