//
//  MockNetworkService.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 19/10/24.
//
import Combine
import Foundation

final class MockNetworkService: NetworkService {
    var result: Result<Data, URLError>
    
    init(result: Result<Data, URLError>) {
        self.result = result
    }
    
    func fetchData(from url: URL) -> AnyPublisher<Data, URLError> {
        switch result {
        case .success(let data):
            return Just(data)
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        case .failure(let urlError):
            return Fail(error: urlError)
                .eraseToAnyPublisher()
        }
    }
}
