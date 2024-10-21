//
//  CityRepository.swift
//  aroundTheWorld
//
//  Created by Federico Lupotti on 20/10/24.
//

import Foundation

protocol CityRepositoryProtocol {
    func updateFavorite(cityID: Int, isFavorite: Bool)
    func getFavorites() -> Set<Int>
}

import Foundation

final class CityRepository: CityRepositoryProtocol {
    
    private let favoritesKey = "favoriteCityIDs"
    
    func updateFavorite(cityID: Int, isFavorite: Bool) {
        var favorites = getFavorites()
        
        if isFavorite {
            favorites.insert(cityID)
        } else {
            favorites.remove(cityID)
        }
        
        saveFavorites(favorites)
    }
    
    func getFavorites() -> Set<Int> {
        if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
            return Set(savedFavorites)
        }
        return []
    }
    
    private func saveFavorites(_ favorites: Set<Int>) {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
}
