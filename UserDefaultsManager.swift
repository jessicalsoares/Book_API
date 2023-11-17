import Foundation
import SwiftUI

public struct FavoriteBooksState {
    private static let key = "FavoriteBooks"
    
    public static func saveFavoritesPublic(_ favorites: [String]) {
           saveFavorites(favorites)
       }

    public static func getFavorites() -> [String] {
        if let data = UserDefaults.standard.data(forKey: key) {
            if let favorites = try? JSONDecoder().decode([String].self, from: data) {
                return favorites
            }
        }
        return []
    }

    public static func addFavorite(bookID: String) {
        var favorites = getFavorites()
        if !favorites.contains(bookID) {
            favorites.append(bookID)
            saveFavorites(favorites)
        }
    }

    public static func removeFavorite(bookID: String) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(of: bookID) {
            favorites.remove(at: index)
            saveFavorites(favorites)
        }
    }

    private static func saveFavorites(_ favorites: [String]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
