@testable import SWPatterns
import XCTest

// Mock for a successful scenario of GetSingleHeroesUseCase
private final class SuccessGetSingleHeroesUseCaseMock: GetSingleHeroesUseCaseContract {
    func execute(with name: String, completion: @escaping (Result<Hero?, Error>) -> Void) {
        // Simulating a successful response with a hero object
        completion(.success(Hero(id: "1234",
                                  name: "Goku",
                                  description: "A powerful Saiyan",
                                  photo: "url_to_photo",
                                  favorite: true)))
    }
}

// Mock for a failed scenario of GetSingleHeroesUseCase
private final class FailedGetSingleHeroesUseCaseMock: GetSingleHeroesUseCaseContract {
    func execute(with name: String, completion: @escaping (Result<Hero?, Error>) -> Void) {
        // Simulating a failure response when fetching a hero
        completion(.failure(APIErrorResponse.unknown("Error fetching hero")))
    }
}

// Mock for a successful scenario of GetAllTransformationsUseCase with no transformations
private final class SuccessGetAllTransformationsUseCaseMock: GetAllTransformationsUseContract {
    func execute(with id: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        // Simulating that the hero has no transformations
        completion(.success([]))
    }
}

// Mock for a failed scenario of GetAllTransformationsUseCase
private final class FailedGetAllTransformationsUseCaseMock: GetAllTransformationsUseContract {
    func execute(with id: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        // Simulating a failure response when fetching transformations
        completion(.failure(APIErrorResponse.unknown("Error fetching transformations")))
    }
}

final class HeroesDetailModelTests: XCTestCase {
    
    // Test case for successfully fetching a hero with no transformations
    func testSuccessScenarioNoTransformations() {
        let successExpectation = expectation(description: "Success")
        let loadingExpectation = expectation(description: "Loading")
        
        let useCaseMock = SuccessGetSingleHeroesUseCaseMock() // Mock for hero fetching
        let transformationsUseCaseMock = SuccessGetAllTransformationsUseCaseMock() // Mock for transformations fetching
        
        // Initialize the ViewModel with mocks
        let sut = HeroesDetailViewModel(heroUseCase: useCaseMock, transformationsUseCase: transformationsUseCaseMock, heroName: "Goku")
        
        // Bind state changes to expectations
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if case .success = state {
                successExpectation.fulfill()
            }
        }
        
        sut.load() // Load hero and transformations
        waitForExpectations(timeout: 5)
        
        // Assert that the hero is loaded correctly
        XCTAssertEqual(sut.hero?.name, "Goku")
        XCTAssertEqual(sut.hero?.id, "1234")
        XCTAssertEqual(sut.hero?.description, "A powerful Saiyan")
        
        // Assert that there are no transformations
        XCTAssertFalse(sut.hasTransformations)
    }
    
    // Test case for failing to fetch a hero
    func testFailHeroScenario() {
        let errorExpectation = expectation(description: "Error")
        let loadingExpectation = expectation(description: "Loading")
        
        let useCaseMock = FailedGetSingleHeroesUseCaseMock() // Mock for failed hero fetching
        let transformationsUseCaseMock = SuccessGetAllTransformationsUseCaseMock() // Mock for successful transformations fetching
        
        // Initialize the ViewModel with mocks
        let sut = HeroesDetailViewModel(heroUseCase: useCaseMock, transformationsUseCase: transformationsUseCaseMock, heroName: "Goku")
        
        // Bind state changes to expectations
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if case .error = state {
                errorExpectation.fulfill()
            }
        }
        
        sut.load() // Attempt to load hero
        waitForExpectations(timeout: 5)
        
        // Assert that no hero is loaded
        XCTAssertNil(sut.hero)
    }
    
    // Test case for failing to fetch transformations
    func testFailTransformationsScenario() {
        let errorExpectation = expectation(description: "Error")
        let loadingExpectation = expectation(description: "Loading")
        
        let useCaseMock = SuccessGetSingleHeroesUseCaseMock() // Mock for successful hero fetching
        let transformationsUseCaseMock = FailedGetAllTransformationsUseCaseMock() // Mock for failed transformations fetching
        
        // Initialize the ViewModel with mocks
        let sut = HeroesDetailViewModel(heroUseCase: useCaseMock, transformationsUseCase: transformationsUseCaseMock, heroName: "Goku")
        
        // Bind state changes to expectations
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if case .error = state {
                errorExpectation.fulfill()
            }
        }
        
        sut.load() // Load hero and transformations
        waitForExpectations(timeout: 5)
        
        // Assert that the hero is loaded correctly
        XCTAssertEqual(sut.hero?.name, "Goku") // Hero should still be loaded successfully
        XCTAssertFalse(sut.hasTransformations) // Ensure transformations are not loaded
    }
}
