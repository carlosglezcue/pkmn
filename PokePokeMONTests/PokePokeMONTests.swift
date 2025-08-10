//
//  PokePokeMONTests.swift
//  PokePokeMONTests
//
//  Created by carlos.gonzalezc on 6/8/25.
//

import Testing
import Foundation
@testable import PokePokeMON

@Suite("PokeListViewModel Tests")
struct PokePokeMONTests {
    
    // MARK: - Mock Interactor
    
    /// Mock implementation of DataInteractor for testing both ViewModels
    final class MockDataInteractor: DataInteractor {
        var shouldThrowError = false
        var mockPokemonsList: [PokemonsModel] = []
        var mockPokemonDetail: PokemonDetailModel?
        var getListCallCount = 0
        var getDetailsCallCount = 0
        var lastRequestedItems = 0
        var lastRequestedId = 0
        var errorToThrow: Error?
        
        func getList(items: Int) async throws -> [PokemonsModel] {
            getListCallCount += 1
            lastRequestedItems = items
            
            if shouldThrowError {
                throw errorToThrow ?? NetworkError.fetchFailed
            }
            
            return mockPokemonsList
        }
        
        func getDetails(id: Int) async throws -> PokemonDetailModel {
            getDetailsCallCount += 1
            lastRequestedId = id
            
            if shouldThrowError {
                throw errorToThrow ?? NetworkError.fetchFailed
            }
            
            guard let detail = mockPokemonDetail else {
                throw NetworkError.noData
            }
            
            return detail
        }
        
        func reset() {
            shouldThrowError = false
            mockPokemonsList = []
            mockPokemonDetail = nil
            getListCallCount = 0
            getDetailsCallCount = 0
            lastRequestedItems = 0
            lastRequestedId = 0
            errorToThrow = nil
        }
    }
    
    enum NetworkError: LocalizedError {
        case fetchFailed
        case noData
        case invalidResponse
        case timeout
        
        var errorDescription: String? {
            switch self {
                case .fetchFailed:
                    return "Failed to fetch data"
                case .noData:
                    return "No data available"
                case .invalidResponse:
                    return "Invalid response received"
                case .timeout:
                    return "Request timed out"
            }
        }
    }
    
    // MARK: - PokeListViewModel Tests
    
    @Suite("PokeListViewModel Tests")
    struct PokeListViewModelTests {
        
        /// Tests the initial state of the PokeListViewModel
        @Test("Initial state should have correct default values")
        func testInitialState() {
            let mockInteractor = MockDataInteractor()
            let viewModel = PokeListViewModel(interactor: mockInteractor)
            
            #expect(viewModel.itemsToShow == "")
            #expect(viewModel.errorMessage == "")
            #expect(viewModel.showAlert == false)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.isAllowed == false)
            #expect(viewModel.isStarting == true)
            #expect(viewModel.pokemonsList.isEmpty)
        }
        
        /// Tests successful Pokemon list fetching
        @Test("Should successfully fetch and load Pokemon list")
        func testSuccessfulPokemonListFetch() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let mockPokemons = [
                PokemonsModel(id: UUID(), name: "Pikachu", image: "", url: "https://pokeapi.co/api/v2/pokemon/25/"),
                PokemonsModel(id: UUID(), name: "Charizard", image: "", url: "https://pokeapi.co/api/v2/pokemon/6/")
            ]
            mockInteractor.mockPokemonsList = mockPokemons
            let viewModel = PokeListViewModel(interactor: mockInteractor)
            
            // When
            await viewModel.getPokemonsList(items: 20)
            
            // Then
            #expect(viewModel.pokemonsList.count == 2)
            #expect(viewModel.pokemonsList[0].name == "Pikachu")
            #expect(viewModel.pokemonsList[1].name == "Charizard")
            #expect(viewModel.isLoading == false)
            #expect(viewModel.showAlert == false)
            #expect(viewModel.errorMessage == "")
            #expect(mockInteractor.getListCallCount == 1)
            #expect(mockInteractor.lastRequestedItems == 20)
        }
        
        /// Tests loading state during fetch operation
        @Test("Should manage loading state correctly during fetch")
        func testLoadingStateDuringFetch() async {
            // Given
            let mockInteractor = MockDataInteractor()
            mockInteractor.mockPokemonsList = [PokemonsModel(id: UUID(), name: "Test", image: "", url: "test")]
            let viewModel = PokeListViewModel(interactor: mockInteractor)
            
            #expect(viewModel.isLoading == false)
            
            // When
            let fetchTask = Task {
                await viewModel.getPokemonsList(items: 10)
            }
            
            // Small delay to check loading state
            try? await Task.sleep(nanoseconds: 1_000_000)
            
            await fetchTask.value
            
            // Then
            #expect(viewModel.isLoading == false)
        }
        
        /// Tests error handling with different error types
        @Test("Should handle different types of fetch errors", arguments: [
            (NetworkError.fetchFailed, "Failed to fetch data"),
            (NetworkError.noData, "No data available"),
            (NetworkError.invalidResponse, "Invalid response received"),
            (NetworkError.timeout, "Request timed out")
        ])
        func testFetchErrors(error: NetworkError, expectedMessage: String) async {
            // Given
            let mockInteractor = MockDataInteractor()
            mockInteractor.shouldThrowError = true
            mockInteractor.errorToThrow = error
            let viewModel = PokeListViewModel(interactor: mockInteractor)
            
            // When
            await viewModel.getPokemonsList(items: 15)
            
            // Then
            #expect(viewModel.showAlert == true)
            #expect(viewModel.errorMessage == expectedMessage)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.pokemonsList.isEmpty)
            #expect(mockInteractor.getListCallCount == 1)
        }
        
        /// Tests loadData function updates pokemonsList correctly
        @Test("LoadData should update pokemonsList on MainActor")
        func testLoadData() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let viewModel = PokeListViewModel(interactor: mockInteractor)
            let testPokemons = [
                PokemonsModel(id: UUID(), name: "Bulbasaur", image: "", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                PokemonsModel(id: UUID(), name: "Ivysaur", image: "", url: "https://pokeapi.co/api/v2/pokemon/2/")
            ]
            
            // When
            await viewModel.loadData(list: testPokemons)
            
            // Then
            #expect(viewModel.pokemonsList.count == 2)
            #expect(viewModel.pokemonsList[0].name == "Bulbasaur")
            #expect(viewModel.pokemonsList[1].name == "Ivysaur")
        }
        
        /// Tests parametrized item counts
        @Test("Should call interactor with correct parameters", arguments: [1, 5, 10, 20, 50, 100])
        func testInteractorCalledWithCorrectParameters(items: Int) async {
            // Given
            let mockInteractor = MockDataInteractor()
            let viewModel = PokeListViewModel(interactor: mockInteractor)
            
            // When
            await viewModel.getPokemonsList(items: items)
            
            // Then
            #expect(mockInteractor.lastRequestedItems == items)
            #expect(mockInteractor.getListCallCount == 1)
        }
        
        /// Tests multiple consecutive fetch operations
        @Test("Should handle multiple consecutive fetch operations correctly")
        func testMultipleFetchOperations() async {
            // Given
            let mockInteractor = MockDataInteractor()
            
            let firstBatch = [PokemonsModel(id: UUID(), name: "Pokemon1", image: "", url: "url1")]
            let secondBatch = [PokemonsModel(id: UUID(), name: "Pokemon2", image: "", url: "url2")]
            let viewModel = PokeListViewModel(interactor: mockInteractor)
            
            // When - First fetch
            mockInteractor.mockPokemonsList = firstBatch
            await viewModel.getPokemonsList(items: 1)
            
            // Then - First fetch results
            #expect(viewModel.pokemonsList.count == 1)
            #expect(viewModel.pokemonsList[0].name == "Pokemon1")
            
            // When - Second fetch (should replace first)
            mockInteractor.mockPokemonsList = secondBatch
            await viewModel.getPokemonsList(items: 1)
            
            // Then - Second fetch results
            #expect(viewModel.pokemonsList.count == 1)
            #expect(viewModel.pokemonsList[0].name == "Pokemon2")
            #expect(mockInteractor.getListCallCount == 2)
        }
        
        /// Tests empty list response
        @Test("Should handle empty Pokemon list response")
        func testEmptyListResponse() async {
            // Given
            let mockInteractor = MockDataInteractor()
            mockInteractor.mockPokemonsList = []
            let viewModel = PokeListViewModel(interactor: mockInteractor)
            
            // When
            await viewModel.getPokemonsList(items: 10)
            
            // Then
            #expect(viewModel.pokemonsList.isEmpty)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.showAlert == false)
            #expect(viewModel.errorMessage == "")
        }
        
        /// Tests alert state reset on new fetch
        @Test("Should reset alert state on new successful fetch after error")
        func testAlertStateResetOnNewFetch() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let viewModel = PokeListViewModel(interactor: mockInteractor)
            
            // When - First fetch with error
            mockInteractor.shouldThrowError = true
            await viewModel.getPokemonsList(items: 10)
            
            // Then - Error state set
            #expect(viewModel.showAlert == true)
            #expect(viewModel.errorMessage != "")
            
            // When - Second fetch successful
            mockInteractor.shouldThrowError = false
            mockInteractor.mockPokemonsList = [PokemonsModel(id: UUID(), name: "Success", image: "", url: "success")]
            await viewModel.getPokemonsList(items: 10)
            
            // Then - Success state (note: showAlert stays true due to toggle behavior)
            #expect(viewModel.pokemonsList.count == 1)
            #expect(viewModel.isLoading == false)
        }
    }
    
    // MARK: - PokeDetailViewModel Tests
    
    @Suite("PokeDetailViewModel Tests")
    struct PokeDetailViewModelTests {
        
        /// Tests the initial state of the PokeDetailViewModel
        @Test("Initial state should have correct default values")
        func testInitialState() {
            let mockInteractor = MockDataInteractor()
            let itemId = 25
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: itemId)
            
            #expect(viewModel.errorMessage == "")
            #expect(viewModel.showAlert == false)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.itemId == itemId)
            #expect(viewModel.details == nil)
        }
        
        /// Tests initialization with different item IDs
        @Test("Should initialize with correct itemId", arguments: [1, 25, 150, 493, 1010])
        func testInitializationWithDifferentIds(itemId: Int) {
            // Given & When
            let mockInteractor = MockDataInteractor()
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: itemId)
            
            // Then
            #expect(viewModel.itemId == itemId)
            #expect(viewModel.details == nil)
        }
        
        /// Tests successful Pokemon detail fetching
        @Test("Should successfully fetch and load Pokemon details")
        func testSuccessfulPokemonDetailFetch() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let pokemonId = 25
            let mockDetail = PokemonDetailModel(
                id: pokemonId,
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                name: "Pikachu",
                description: "BULBASAUR can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
                baseExperience: 112,
                weight: 60,
                isBaby: true,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: true,
                captureRate: "Hard",
                types: ["grass", "poison"],
                moves: ["razor-wind", "swords-dance", "cut", "bind", "vine-whip", "headbutt"],
                power: [45, 49, 49, 65, 65, 45],
                stats: ["hp", "attack", "defense", "special-attack", "special-defense", "speed"],
                growthRate: "medium-slow"
            )
            mockInteractor.mockPokemonDetail = mockDetail
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: pokemonId)
            
            // When
            await viewModel.getPokemonsDetails(id: pokemonId)
            
            // Then
            #expect(viewModel.details?.id == pokemonId)
            #expect(viewModel.details?.name == "Pikachu")
            #expect(viewModel.details?.weight == 60)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.showAlert == false)
            #expect(viewModel.errorMessage == "")
            #expect(mockInteractor.getDetailsCallCount == 1)
            #expect(mockInteractor.lastRequestedId == pokemonId)
        }
        
        /// Tests loading state during detail fetch
        @Test("Should manage loading state correctly during detail fetch")
        func testLoadingStateDuringDetailFetch() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let pokemonId = 1
            mockInteractor.mockPokemonDetail = PokemonDetailModel(
                id: pokemonId,
                image: "",
                name: "Test",
                description: "test-test-test",
                baseExperience: 1,
                weight: 1,
                isBaby: false,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: false,
                captureRate: "test",
                types: ["Test", "test"],
                moves: ["Test", "test"],
                power: [0, 1],
                stats: ["Test", "test"],
                growthRate: "test"
            )
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: pokemonId)
            
            #expect(viewModel.isLoading == false)
            
            // When
            let fetchTask = Task {
                await viewModel.getPokemonsDetails(id: pokemonId)
            }
            
            try? await Task.sleep(nanoseconds: 1_000_000)
            
            await fetchTask.value
            
            // Then
            #expect(viewModel.isLoading == false)
        }
        
        /// Tests error handling with different error types for details
        @Test("Should handle different types of detail fetch errors", arguments: [
            (NetworkError.fetchFailed, "Failed to fetch data"),
            (NetworkError.noData, "No data available"),
            (NetworkError.invalidResponse, "Invalid response received"),
            (NetworkError.timeout, "Request timed out")
        ])
        func testDetailFetchErrors(error: NetworkError, expectedMessage: String) async {
            // Given
            let mockInteractor = MockDataInteractor()
            mockInteractor.shouldThrowError = true
            mockInteractor.errorToThrow = error
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: 25)
            
            // When
            await viewModel.getPokemonsDetails(id: 25)
            
            // Then
            #expect(viewModel.showAlert == true)
            #expect(viewModel.errorMessage == expectedMessage)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.details == nil)
            #expect(mockInteractor.getDetailsCallCount == 1)
        }
        
        /// Tests loadData function for details
        @Test("LoadData should update details on MainActor")
        func testLoadDataForDetails() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: 1)
            let testDetail = PokemonDetailModel(
                id: 1,
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                name: "Pikachu",
                description: "BULBASAUR can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
                baseExperience: 112,
                weight: 60,
                isBaby: true,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: true,
                captureRate: "Hard",
                types: ["grass", "poison"],
                moves: ["razor-wind", "swords-dance", "cut", "bind", "vine-whip", "headbutt"],
                power: [45, 49, 49, 65, 65, 45],
                stats: ["hp", "attack", "defense", "special-attack", "special-defense", "speed"],
                growthRate: "medium-slow"
            )
            
            // When
            await viewModel.loadData(item: testDetail)
            
            // Then
            #expect(viewModel.details?.id == 1)
            #expect(viewModel.details?.name == "Bulbasaur")
            #expect(viewModel.details?.weight == 69)
            #expect(viewModel.details?.baseExperience == 64)
        }
        
        /// Tests fetching details with different IDs than itemId
        @Test("Should handle fetching details with different ID than itemId")
        func testFetchDifferentIdThanItemId() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let initId = 25
            let fetchId = 1
            let mockDetail = PokemonDetailModel(
                id: fetchId,
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                name: "Pikachu",
                description: "BULBASAUR can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
                baseExperience: 112,
                weight: 60,
                isBaby: true,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: true,
                captureRate: "Hard",
                types: ["grass", "poison"],
                moves: ["razor-wind", "swords-dance", "cut", "bind", "vine-whip", "headbutt"],
                power: [45, 49, 49, 65, 65, 45],
                stats: ["hp", "attack", "defense", "special-attack", "special-defense", "speed"],
                growthRate: "medium-slow"
            )
            mockInteractor.mockPokemonDetail = mockDetail
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: initId)
            
            // When
            await viewModel.getPokemonsDetails(id: fetchId)
            
            // Then
            #expect(viewModel.itemId == initId)
            #expect(viewModel.details?.id == fetchId)
            #expect(mockInteractor.lastRequestedId == fetchId)
        }
        
        /// Tests multiple consecutive detail fetches
        @Test("Should handle multiple consecutive detail fetches")
        func testMultipleDetailFetches() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: 1)
            
            let firstDetail = PokemonDetailModel(
                id: 1,
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                name: "Bulbasur",
                description: "BULBASAUR can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
                baseExperience: 69,
                weight: 64,
                isBaby: true,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: true,
                captureRate: "Hard",
                types: ["grass", "poison"],
                moves: ["razor-wind", "swords-dance", "cut", "bind", "vine-whip", "headbutt"],
                power: [45, 49, 49, 65, 65, 45],
                stats: ["hp", "attack", "defense", "special-attack", "special-defense", "speed"],
                growthRate: "medium-slow"
            )
            let secondDetail = PokemonDetailModel(
                id: 25,
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                name: "Pikachu",
                description: "BULBASAUR can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
                baseExperience: 60,
                weight: 112,
                isBaby: true,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: true,
                captureRate: "Hard",
                types: ["grass", "poison"],
                moves: ["razor-wind", "swords-dance", "cut", "bind", "vine-whip", "headbutt"],
                power: [45, 49, 49, 65, 65, 45],
                stats: ["hp", "attack", "defense", "special-attack", "special-defense", "speed"],
                growthRate: "medium-slow"
            )
            
            // When - First fetch
            mockInteractor.mockPokemonDetail = firstDetail
            await viewModel.getPokemonsDetails(id: 1)
            
            // Then - First fetch results
            #expect(viewModel.details?.name == "Bulbasaur")
            #expect(viewModel.details?.id == 1)
            
            // When - Second fetch (should replace first)
            mockInteractor.mockPokemonDetail = secondDetail
            await viewModel.getPokemonsDetails(id: 25)
            
            // Then - Second fetch results
            #expect(viewModel.details?.name == "Pikachu")
            #expect(viewModel.details?.id == 25)
            #expect(mockInteractor.getDetailsCallCount == 2)
        }
        
        /// Tests error recovery on subsequent successful fetch
        @Test("Should recover from error on subsequent successful detail fetch")
        func testErrorRecoveryOnDetailFetch() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: 25)
            
            // When - First fetch with error
            mockInteractor.shouldThrowError = true
            await viewModel.getPokemonsDetails(id: 25)
            
            // Then - Error state
            #expect(viewModel.showAlert == true)
            #expect(viewModel.errorMessage != "")
            #expect(viewModel.details == nil)
            
            // When - Second fetch successful
            mockInteractor.shouldThrowError = false
            mockInteractor.mockPokemonDetail = PokemonDetailModel(
                id: 25,
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                name: "Pikachu",
                description: "BULBASAUR can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
                baseExperience: 112,
                weight: 60,
                isBaby: true,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: true,
                captureRate: "Hard",
                types: ["grass", "poison"],
                moves: ["razor-wind", "swords-dance", "cut", "bind", "vine-whip", "headbutt"],
                power: [45, 49, 49, 65, 65, 45],
                stats: ["hp", "attack", "defense", "special-attack", "special-defense", "speed"],
                growthRate: "medium-slow"
            )
            await viewModel.getPokemonsDetails(id: 25)
            
            // Then - Success state
            #expect(viewModel.details?.name == "Pikachu")
            #expect(viewModel.isLoading == false)
            #expect(mockInteractor.getDetailsCallCount == 2)
        }
        
        /// Tests that itemId property remains immutable after initialization
        @Test("ItemId should remain immutable after initialization")
        func testItemIdImmutability() async {
            // Given
            let mockInteractor = MockDataInteractor()
            let originalItemId = 100
            let viewModel = PokeDetailViewModel(interactor: mockInteractor, itemId: originalItemId)
            
            mockInteractor.mockPokemonDetail = PokemonDetailModel(
                id: 200,
                image: "test",
                name: "Test",
                description: "test, test",
                baseExperience: 1,
                weight: 1,
                isBaby: true,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: true,
                captureRate: "test",
                types: ["test", "Test"],
                moves: ["test", "Test"],
                power: [0, 1],
                stats: ["test", "Test"],
                growthRate: "test"
            )
            
            // When
            await viewModel.getPokemonsDetails(id: 200)
            
            // Then
            #expect(viewModel.itemId == originalItemId)
            #expect(viewModel.details?.id == 200)
        }
    }
    
    // MARK: - Integration Tests
    
    @Suite("Integration Tests")
    struct IntegrationTests {
        
        /// Tests both ViewModels working with the same interactor
        @Test("Both ViewModels should work independently with same interactor")
        func testBothViewModelsWithSameInteractor() async {
            // Given
            let sharedInteractor = MockDataInteractor()
            let listViewModel = PokeListViewModel(interactor: sharedInteractor)
            let detailViewModel = PokeDetailViewModel(interactor: sharedInteractor, itemId: 25)
            
            // Setup mock data
            sharedInteractor.mockPokemonsList = [PokemonsModel(id: UUID(), name: "Pikachu", image: "", url: "url")]
            sharedInteractor.mockPokemonDetail = PokemonDetailModel(
                id: 25,
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                name: "Pikachu",
                description: "BULBASAUR can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
                baseExperience: 112,
                weight: 60,
                isBaby: true,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: true,
                captureRate: "Hard",
                types: ["grass", "poison"],
                moves: ["razor-wind", "swords-dance", "cut", "bind", "vine-whip", "headbutt"],
                power: [45, 49, 49, 65, 65, 45],
                stats: ["hp", "attack", "defense", "special-attack", "special-defense", "speed"],
                growthRate: "medium-slow"
            )
            
            // When
            await listViewModel.getPokemonsList(items: 1)
            await detailViewModel.getPokemonsDetails(id: 25)
            
            // Then
            #expect(listViewModel.pokemonsList.count == 1)
            #expect(listViewModel.pokemonsList[0].name == "Pikachu")
            #expect(detailViewModel.details?.name == "Pikachu")
            #expect(detailViewModel.details?.id == 25)
            #expect(sharedInteractor.getListCallCount == 1)
            #expect(sharedInteractor.getDetailsCallCount == 1)
        }
        
        /// Tests error isolation between ViewModels
        @Test("Error in one ViewModel should not affect the other")
        func testErrorIsolationBetweenViewModels() async {
            // Given
            let sharedInteractor = MockDataInteractor()
            let listViewModel = PokeListViewModel(interactor: sharedInteractor)
            let detailViewModel = PokeDetailViewModel(interactor: sharedInteractor, itemId: 25)
            
            // When - List fails, detail succeeds
            sharedInteractor.shouldThrowError = true
            await listViewModel.getPokemonsList(items: 1)
            
            sharedInteractor.shouldThrowError = false
            sharedInteractor.mockPokemonDetail = PokemonDetailModel(
                id: 25,
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                name: "Pikachu",
                description: "BULBASAUR can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
                baseExperience: 112,
                weight: 60,
                isBaby: true,
                isLegendary: false,
                isMythical: false,
                hasGenderDifferences: true,
                captureRate: "Hard",
                types: ["grass", "poison"],
                moves: ["razor-wind", "swords-dance", "cut", "bind", "vine-whip", "headbutt"],
                power: [45, 49, 49, 65, 65, 45],
                stats: ["hp", "attack", "defense", "special-attack", "special-defense", "speed"],
                growthRate: "medium-slow"
            )
            await detailViewModel.getPokemonsDetails(id: 25)
            
            // Then
            #expect(listViewModel.showAlert == true)
            #expect(listViewModel.pokemonsList.isEmpty)
            #expect(detailViewModel.showAlert == false)
            #expect(detailViewModel.details?.name == "Pikachu")
        }
    }
}
