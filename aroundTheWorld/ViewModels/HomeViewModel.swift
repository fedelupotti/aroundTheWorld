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

    private let apiService: APIService
    
    private var cancellables = Set<AnyCancellable>()
    
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
                self?.cities = cities
            })
            .store(in: &cancellables)
    }
}
