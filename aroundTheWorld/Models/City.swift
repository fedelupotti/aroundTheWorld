//
//  City.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//

import Foundation

struct City: Decodable, Identifiable, Encodable {
    let country: String?
    let name: String?
    let id: Int?
    let coordinate: Coordinate?
    var isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coordinate = "coord"
        case isFavorite
    }
}

struct Coordinate: Decodable, Encodable {
    let lon: Double?
    let lat: Double?
}

#if DEBUG
extension City {
    static let mock: [Self] = [
        City(country: "UA", name: "Hurzuf", id: 002020, coordinate: Coordinate(lon: 34.283333, lat: 44.549999)),
        City(country: "US", name: "New York", id: 5128581, coordinate: Coordinate(lon: -74.0060, lat: 40.7128)),
        City(country: "CA", name: "Vancouver", id: 6077243, coordinate: Coordinate(lon: -123.1207, lat: 49.2827)),
    ]
}
#endif
