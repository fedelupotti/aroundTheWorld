//
//  aroundTheWorldTests.swift
//  aroundTheWorldTests
//
//  Created by Federico Lupotti on 19/10/24.
//
import Combine
import XCTest
@testable import aroundTheWorld

final class aroundTheWorldTests: XCTestCase {
    var sut: APIService!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService(result: .success(Data()))
        sut = APIService(networkService: mockNetworkService)
        cancellables = []
    }

    override func tearDownWithError() throws {
        sut = nil
        mockNetworkService = nil
        cancellables = nil
    }
    
    func test_apiService_fetchCities_badUrl() {
        //Given
        mockNetworkService = MockNetworkService(result: .failure(URLError(.badURL)))
        sut = APIService(networkService: mockNetworkService)
        
        let expectation = XCTestExpectation(description: "Fetch cities failure")
        
        //When
        sut.fetchCities()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    //Then
                    XCTAssertEqual((error as? URLError)?.code, .badURL)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                    XCTFail()
            })
            .store(in: &cancellables)
    }

    func test_apiService_fetchCities_citiesIsNotEmpty() throws {
        //Given
        let mockCity = [City(country: "Argentina", name: "Santa Fe", id: 3000, coordinate: nil)]
        
        let encoder = JSONEncoder()
        let mockCityJson = try encoder.encode(mockCity)
        
        mockNetworkService = MockNetworkService(result: .success(mockCityJson))
        sut = APIService(networkService: mockNetworkService)
        
        let expectation = XCTestExpectation(description: "City is not empty")
        
        //When
        sut.fetchCities()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Should receive \(mockCity) and receive \(error)")
                }
            }, receiveValue: { cities in
                
                //Then
                XCTAssertTrue(!cities.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)
    }
}
