//
//  HomeViewModel.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//
import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var cities: [City] = []
    @Published var searchableText = ""

    private let apiService: APIService
    
    private var cancellables = Set<AnyCancellable>()
    
    var serachableCities: [City] {
        if searchableText.isEmpty { return cities }
        return cities.filter { $0.name?.lowercased().contains(searchableText.lowercased()) ?? false }
    }
    
    init(apiService: APIService) {
        self.apiService = apiService
        
        onFetchSubscribe()
    }
    
    private func onFetchSubscribe() {
        apiService.fetchCities()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }, receiveValue: { [weak self] cities in
                let sortedCities = self?.sortByName(for: cities) ?? []
                self?.cities = sortedCities
            })
            .store(in: &cancellables)
    }
    
    private func sortByName(for cities: [City]) -> [City] {
        return cities.sorted(by: { $0.name ?? "" < $1.name ?? "" })
    }
}
