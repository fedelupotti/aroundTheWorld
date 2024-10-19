//
//  APIService.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//
import Combine
import Foundation

protocol NetworkService {
    func fetchData(from url: URL) -> AnyPublisher<Data, URLError>
}

final class APIService: ObservableObject {    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = URLSession.shared) {
        self.networkService = networkService
    }
    
    func fetchCities() -> AnyPublisher<[City], Error> {
        let citiesUrlString = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        
        guard let citiesURL = URL(string: citiesUrlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        let decoder = JSONDecoder()
        return networkService.fetchData(from: citiesURL)
            .decode(type: [City].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

extension URLSession: NetworkService {
    func fetchData(from url: URL) -> AnyPublisher<Data, URLError> {
        return dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
