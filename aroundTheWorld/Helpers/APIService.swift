//
//  APIService.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//
import Combine
import Foundation

final class APIService: ObservableObject {
    @Published private(set) var cities: [City] = []
    
    func fetchCities() -> AnyPublisher<[City], Error> {
        let citiesUrlString = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        
        guard let citiesURL = URL(string: citiesUrlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        let decoder = JSONDecoder()
        return URLSession.shared.dataTaskPublisher(for: citiesURL)
            .map { $0.data }
            .decode(type: [City].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
