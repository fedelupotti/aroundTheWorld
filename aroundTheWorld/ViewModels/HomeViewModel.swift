//
//  HomeViewModel.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 16/10/24.
//
import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var cities: [Int: City] = [:]
    
    @Published var searchableText = ""
    
    @Published private(set) var citiesSearched: [City] = []
    @Published private(set) var citiesFavoritesSearched: [City] = []
    
    @Published private(set) var isLoading = false

    private let apiService: APIService
    private let cityRepository: CityRepositoryProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        apiService: APIService = APIService(),
        cityRepository: CityRepositoryProtocol = CityRepository()
    ) {
        self.apiService = apiService
        self.cityRepository = cityRepository
        onSearchableSubscribe()
    }
    
    func fetchCities() {
        onFetchSubscribe()
    }
    
    private func onSearchableSubscribe() {
        $searchableText
            .combineLatest($cities)
            .map { [weak self] (text, citiesDict) -> [City] in
                guard let self else { return  [] }
                
                let cities = Array(citiesDict.values)
                let citiesSorted = self.getSortCitiesByName(for: cities)
                
                if text.isEmpty { return citiesSorted }
                
                return filterBySearchWith(prefix: text, from: citiesSorted)
            }
            .assign(to: &$citiesSearched)
        
        $searchableText
            .combineLatest($cities)
            .map { [weak self] (text, citiesDict) -> [City] in
                guard let self else { return [] }
                
                let cities = Array(citiesDict.values)
                let citiesSorted = self.getSortCitiesByName(for: cities)
                
                if text.isEmpty { return citiesSorted.filter { $0.isFavorite == true } }
                
                let citiesFilterBySearchInput = filterBySearchWith(prefix: text, from: citiesSorted)
                let citiesWithFavorites = filterByFavorites(from: citiesFilterBySearchInput)
                
                return citiesWithFavorites
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
                guard let self else { return }
                
                let sortedCitiesDictionary = self.transformToCitiesDictionary(for: cities)
                let localFavoriteIDs = self.cityRepository.getFavorites()
                
                self.cities = applyFavoritesCitiesFrom(ids: localFavoriteIDs, to: sortedCitiesDictionary)
                
            })
            .store(in: &cancellables)
    }
    
    private func filterBySearchWith(prefix: String, from cities: [City]) -> [City] {
        cities.filter { $0.name?.lowercased().hasPrefix(prefix.lowercased()) ?? false }
    }
    
    private func filterByFavorites(from cities: [City]) -> [City] {
        cities.filter( { $0.isFavorite == true })
    }
    
    private func transformToCitiesDictionary(for cities: [City]) -> [Int: City] {
        var citiesDictionary = [Int: City]()
        
        citiesDictionary = Dictionary(uniqueKeysWithValues: cities.map { city -> (Int, City) in
            return (city.id ?? Int(), city)
            })
        return citiesDictionary
    }
    
    private func applyFavoritesCitiesFrom(ids: Set<Int>,to citiesDict: [Int : City]) -> [Int : City] {
        var citiesDictionaryWithFavorites = citiesDict
        for id in ids {
            citiesDictionaryWithFavorites[id]?.isFavorite = true
        }
        return citiesDictionaryWithFavorites
    }
    
    func updateCity(_ city: City, isFavorite: Bool) {
        guard let cityId = city.id else { return }
        cities[cityId]?.isFavorite = isFavorite
        
        cityRepository.updateFavorite(cityID: cityId, isFavorite: isFavorite)
    }
    
    private func getSortCitiesByName(for cities: [City]) -> [City] {
        return cities.sorted(by: { $0.name ?? "" < $1.name ?? "" })
    }
    
    func sortByName_Testing(for cities: [City]) -> [City] {
        return getSortCitiesByName(for: cities)
    }
    
    func filterBySearchWith_Testing(prefix: String, from cities: [City]) -> [City] {
        return filterBySearchWith(prefix: prefix, from: cities)
    }
}

