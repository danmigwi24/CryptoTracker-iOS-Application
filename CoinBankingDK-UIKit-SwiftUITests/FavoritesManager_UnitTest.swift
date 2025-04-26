//
//  FavoritesManager_UnitTest.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//

import XCTest
@testable import CoinBankingDK_UIKit_SwiftUI // Replace with your actual app module name

class FavoritesManagerTests: XCTestCase {
    
    var favoritesManager: FavoritesManager!
    let testCoinId1 = "bitcoin"
    let testCoinId2 = "ethereum"
    let testCoinId3 = "litecoin"
    
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "favoritedCoins")
        favoritesManager = FavoritesManager.shared
    }
    
    override func tearDown() {
        // Clean up after each test
        UserDefaults.standard.removeObject(forKey: "favoritedCoins")
        favoritesManager = nil
        super.tearDown()
    }
    
    func testInitialStateIsEmpty() {
        XCTAssertTrue(favoritesManager.getFavorites().isEmpty, "Favorites should be empty initially")
    }
    
    func testAddFavorite() {
        favoritesManager.addFavorite(coinId: testCoinId1)
        XCTAssertEqual(favoritesManager.getFavorites(), [testCoinId1], "Should contain the added coin")
        XCTAssertTrue(favoritesManager.isFavorite(coinId: testCoinId1), "Coin should be marked as favorite")
    }
    
    func testAddDuplicateFavorite() {
        favoritesManager.addFavorite(coinId: testCoinId1)
        favoritesManager.addFavorite(coinId: testCoinId1)
        XCTAssertEqual(favoritesManager.getFavorites().count, 1, "Should not add duplicate favorites")
    }
    
    func testRemoveFavorite() {
        favoritesManager.addFavorite(coinId: testCoinId1)
        favoritesManager.removeFavorite(coinId: testCoinId1)
        XCTAssertTrue(favoritesManager.getFavorites().isEmpty, "Favorites should be empty after removal")
        XCTAssertFalse(favoritesManager.isFavorite(coinId: testCoinId1), "Coin should not be favorite after removal")
    }
    
    func testRemoveNonExistentFavorite() {
        favoritesManager.removeFavorite(coinId: "non-existent-coin")
        XCTAssertTrue(favoritesManager.getFavorites().isEmpty, "Removing non-existent favorite should not change favorites")
    }
    
    func testToggleFavorite() {
        // First toggle should add
        favoritesManager.toggleFavorite(coinId: testCoinId1)
        XCTAssertTrue(favoritesManager.isFavorite(coinId: testCoinId1), "First toggle should add favorite")
        
        // Second toggle should remove
        favoritesManager.toggleFavorite(coinId: testCoinId1)
        XCTAssertFalse(favoritesManager.isFavorite(coinId: testCoinId1), "Second toggle should remove favorite")
    }
    
    func testMultipleFavorites() {
        favoritesManager.addFavorite(coinId: testCoinId1)
        favoritesManager.addFavorite(coinId: testCoinId2)
        favoritesManager.addFavorite(coinId: testCoinId3)
        
        XCTAssertEqual(favoritesManager.getFavorites().count, 3, "Should contain all added favorites")
        XCTAssertTrue(favoritesManager.isFavorite(coinId: testCoinId1))
        XCTAssertTrue(favoritesManager.isFavorite(coinId: testCoinId2))
        XCTAssertTrue(favoritesManager.isFavorite(coinId: testCoinId3))
        
        favoritesManager.removeFavorite(coinId: testCoinId2)
        XCTAssertEqual(favoritesManager.getFavorites(), [testCoinId1, testCoinId3], "Should only contain remaining favorites")
    }
    
    func testPersistence() {
        favoritesManager.addFavorite(coinId: testCoinId1)
        favoritesManager.addFavorite(coinId: testCoinId2)
        
        // Create a new instance to test persistence
        let newManager = FavoritesManager.shared
        XCTAssertEqual(newManager.getFavorites(), [testCoinId1, testCoinId2], "Favorites should persist between instances")
    }
    
    func testPublishedPropertyUpdates() {
        let expectation = XCTestExpectation(description: "Published property should update")
        let cancellable = favoritesManager.$favorites
            .dropFirst() // Ignore initial value
            .sink { favorites in
                XCTAssertEqual(favorites, [self.testCoinId1], "Published favorites should update when adding")
                expectation.fulfill()
            }
        
        favoritesManager.addFavorite(coinId: testCoinId1)
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }
}
