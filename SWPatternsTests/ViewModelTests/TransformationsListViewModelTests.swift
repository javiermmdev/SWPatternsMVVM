@testable import SWPatterns
import XCTest

// Mock for a successful GetAllTransformationsUseCase scenario
private final class SuccessGetAllTransformationsUseCaseMock: GetAllTransformationsUseContract {
    func execute(with id: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        // Create a dummy array of transformations to return
        let transformations = [
            Transformation(id: "1", name: "Super Saiyan", description: "Gains immense power", photo: "url1", hero: HeroIDContainer(id: "1234")),
            Transformation(id: "2", name: "Super Saiyan Blue", description: "Power of Super Saiyan God", photo: "url2", hero: HeroIDContainer(id: "1234")),
            Transformation(id: "3", name: "Ultra Instinct", description: "Beyond Super Saiyan", photo: "url3", hero: HeroIDContainer(id: "1234"))
        ]
        completion(.success(transformations)) // Return the transformations successfully
    }
}

// Mock for a failed GetAllTransformationsUseCase scenario
private final class FailedGetAllTransformationsUseCaseMock: GetAllTransformationsUseContract {
    func execute(with id: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        // Simulate a failure response with an error message
        completion(.failure(APIErrorResponse.network("Error fetching transformations")))
    }
}

final class TransformationListViewModelTests: XCTestCase {

    // Test case for successfully fetching transformations
    func testGetAllTransformationsSuccess() {
        let successExpectation = expectation(description: "GetAllTransformationsSuccess") // Expectation for success case
        let loadingExpectation = expectation(description: "Loading") // Expectation for loading state
        
        let useCaseMock = SuccessGetAllTransformationsUseCaseMock() // Use the successful mock
        let sut = TransformationListViewModel(useCase: useCaseMock, heroId: "1234") // Initialize the ViewModel
        
        // Bind state changes to expectations
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill() // Fulfill loading expectation
            } else if case .success = state {
                successExpectation.fulfill() // Fulfill success expectation
            }
        }
        
        sut.load() // Trigger loading
        waitForExpectations(timeout: 5) // Wait for expectations to be fulfilled
        
        // Check that the transformations are loaded correctly
        XCTAssertEqual(sut.transformations.count, 3) // Expecting 3 transformations
        XCTAssertEqual(sut.transformations.first?.name, "Super Saiyan") // Check the first transformation
    }
    
    // Test case for failing to fetch transformations
    func testGetAllTransformationsFailure() {
        let errorExpectation = expectation(description: "GetAllTransformationsFailure") // Expectation for failure case
        let loadingExpectation = expectation(description: "Loading") // Expectation for loading state
        
        let useCaseMock = FailedGetAllTransformationsUseCaseMock() // Use the failed mock
        let sut = TransformationListViewModel(useCase: useCaseMock, heroId: "1234") // Initialize the ViewModel
        
        // Bind state changes to expectations
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill() // Fulfill loading expectation
            } else if case .error = state {
                errorExpectation.fulfill() // Fulfill error expectation
            }
        }
        
        sut.load() // Trigger loading
        waitForExpectations(timeout: 5) // Wait for expectations to be fulfilled
        
        XCTAssertEqual(sut.transformations.count, 0) // Expecting no transformations
    }
}
