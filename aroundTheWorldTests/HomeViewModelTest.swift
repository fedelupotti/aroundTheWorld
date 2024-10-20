//
//  HomeViewModelTest.swift
//  aroundTheWorldTests
//
//  Created by Federico Lupotti on 19/10/24.
//
import Combine
import XCTest
@testable import aroundTheWorld

final class HomeViewModelTest: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var apiService: APIService!
    var sut: HomeViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService(result: .success(Data()))
        apiService = APIService(networkService: mockNetworkService)
        sut = HomeViewModel(apiService: apiService)
        cancellables = []
    }

    override func tearDownWithError() throws {
        mockNetworkService = nil
        apiService = nil
        sut = nil
        cancellables = nil
    }

    func test_homeViewModel_cities_correctSubscribe() throws {
        //Given
        let mockCity = [City(country: "Argentina", name: "Santa Fe", id: 3000, coordinate: nil)]
        
        let encoder = JSONEncoder()
        let mockCityJson = try encoder.encode(mockCity)
        
        //when
        mockNetworkService = MockNetworkService(result: .success(mockCityJson))
        apiService = APIService(networkService: mockNetworkService)
        sut = HomeViewModel(apiService: apiService)
        
        let expectation = XCTestExpectation(description: "Cities receive city correctly")
        
        sut.$cities
            .dropFirst()
            .sink(receiveValue: { cities in
                //Then
                XCTAssertTrue(cities[0]?.id == mockCity[0].id)
                expectation.fulfill()
            })
            .store(in: &cancellables)
    }
    
    func test_homeViewModel_isLoading_inicializeFalse() throws {
        //Given
        let mockCity = [City(country: "Argentina", name: "Santa Fe", id: 3000, coordinate: nil)]
        
        let encoder = JSONEncoder()
        let mockCityJson = try encoder.encode(mockCity)
        
        //when
        mockNetworkService = MockNetworkService(result: .success(mockCityJson))
        apiService = APIService(networkService: mockNetworkService)
        sut = HomeViewModel(apiService: apiService)
        
        //Then
        XCTAssertFalse(sut.isLoading, "El valor inicial de isLoading debería ser true al inicializar el HomeViewModel")
    }
    
    func test_homeViewModel_isLoading_isTrueOnFetch() throws {
        //Given
        let mockCity = [City(country: "Argentina", name: "Santa Fe", id: 3000, coordinate: nil)]
        
        let encoder = JSONEncoder()
        let mockCityJson = try encoder.encode(mockCity)
        
        //when
        mockNetworkService = MockNetworkService(result: .success(mockCityJson))
        apiService = APIService(networkService: mockNetworkService)
        sut = HomeViewModel(apiService: apiService)
        
        let expectation = XCTestExpectation(description: "isLoading true after onFetchSubscription")
        
        sut.$isLoading
            .dropFirst()
            .sink { isLoading in
                //Then
                XCTAssertTrue(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
    }
    
    func test_homeViewModel_isLoading_restoreToFalse() throws {
        //Given
        let mockCity = [City(country: "Argentina", name: "Santa Fe", id: 3000, coordinate: nil)]
        
        let encoder = JSONEncoder()
        let mockCityJson = try encoder.encode(mockCity)
        
        //when
        mockNetworkService = MockNetworkService(result: .success(mockCityJson))
        apiService = APIService(networkService: mockNetworkService)
        sut = HomeViewModel(apiService: apiService)
        
        let expectation = XCTestExpectation(description: "isLoading true after onFetchSubscription")
        
        sut.$isLoading
            .dropFirst()
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { isLoading in
                //Then
                XCTAssertFalse(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
    }
    
    func test_homeViewModel_sortByName_correctSort() throws {
        //Given
        let mockCity = [
            City(country: "Argentina", name: "Santa Fe", id: 3000, coordinate: nil),
            City(country: "Argentina", name: "Cordoba", id: 3001, coordinate: nil),
        ]
        
        let encoder = JSONEncoder()
        let mockCityJson = try encoder.encode(mockCity)
        
        //when
        mockNetworkService = MockNetworkService(result: .success(mockCityJson))
        apiService = APIService(networkService: mockNetworkService)
        sut = HomeViewModel(apiService: apiService)
        
        let citiesSortedByName = sut.sortByNameTesting(for: mockCity)
        
        //Then
        XCTAssertTrue(citiesSortedByName[0].id == 3001)
    }
}
