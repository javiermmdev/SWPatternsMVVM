@testable import SWPatterns
import XCTest

// Mock for a successful scenario of GetAllHeroesUseCase
private final class SuccessGetHeroesUseCaseMock: GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[SWPatterns.Hero], any Error>) -> Void) {
        // Simulate a successful response with a single hero
        completion(.success([Hero(id: "1234",
                                  name: "potato",
                                  description: "",
                                  photo: "",
                                  favorite: false)]))
    }
}

// Mock for a failed scenario of GetAllHeroesUseCase
private final class FailedGetHeroesUseCaseMock: GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[SWPatterns.Hero], any Error>) -> Void) {
        // Simulate a failure response
        completion(.failure(APIErrorResponse.unknown("")))
    }
}

final class HeroesListViewModelTests: XCTestCase {
    
    // Test case for the success scenario
    func testSuccessScenario() {
        let successExpectation = expectation(description: "Success")
        let loadingExpectation = expectation(description: "Loading")
        
        let useCaseMock = SuccessGetHeroesUseCaseMock() // Mock for successful hero fetching
        let sut = HeroesListViewModel(useCase: useCaseMock) // Initialize ViewModel with the mock
        
        // Bind the state changes to expectations
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill() // Fulfill loading expectation when loading starts
            } else if state == .success {
                successExpectation.fulfill() // Fulfill success expectation when load is successful
            }
        }
        
        sut.load() // Trigger the loading of heroes
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.heroes.count, 1) // Assert that one hero was fetched
    }
    
    // Test case for the failure scenario
    func testFailScenario() {
        let errorExpectation = expectation(description: "Error")
        let loadingExpectation = expectation(description: "Loading")
        
        let useCaseMock = FailedGetHeroesUseCaseMock() // Mock for failed hero fetching
        let sut = HeroesListViewModel(useCase: useCaseMock) // Initialize ViewModel with the mock
        
        // Bind the state changes to expectations
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill() // Fulfill loading expectation when loading starts
            } else if case .error = state {
                errorExpectation.fulfill() // Fulfill error expectation when load fails
            }
        }
        
        sut.load() // Trigger the loading of heroes
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.heroes.count, 0) // Assert that no heroes were fetched
    }
}
