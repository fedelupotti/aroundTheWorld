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
    
    @Published private(set) var citiesSearched: [City] = []
    @Published private(set) var citiesFavoritesSearched: [City] = []
    
    @Published private(set) var isLoading = false

    private let apiService: APIService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIService) {
        self.apiService = apiService
        
        onSearchableSubscribe()
    }
    
    func fetchCities() {
        onFetchSubscribe()
    }
    
    private func onSearchableSubscribe() {
        $searchableText
            .combineLatest($cities)
            .map { (text, cities) -> [City] in
                if text.isEmpty { return cities }
                return cities.filter { $0.name?.lowercased().contains(text.lowercased()) ?? false }
            }
            .assign(to: &$citiesSearched)
        
        $searchableText
            .combineLatest($cities)
            .map { (text, cities) -> [City] in
                if text.isEmpty { return cities.filter({ $0.isFavorite == true }) }
                return cities.filter { $0.name?.lowercased().contains(text.lowercased()) ?? false && $0.isFavorite == true }
            }
            .assign(to: &$citiesFavoritesSearched)
    }
    
    private func onFetchSubscribe() {
        isLoading = true
        
        apiService.fetchCities()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                defer { self?.isLoading = false }
                
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
    
    func updateCity(_ city: City, isFavorite: Bool) {
        guard let index = cities.firstIndex(where: { $0.id == city.id }) else { return }
        cities[index].isFavorite = isFavorite
    }
    
    func sortByNameTesting(for cities: [City]) -> [City] {
        return sortByName(for: cities)
    }
}
