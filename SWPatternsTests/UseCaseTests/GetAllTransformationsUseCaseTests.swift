@testable import SWPatterns
import XCTest

// Mock for a successful scenario of GetAllTransformationsUseCase
private final class SuccessGetAllTransformationsUseCaseMock: GetAllTransformationsUseContract {
    func execute(with id: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        // Prepare dummy transformation data
        let transformations = [
            Transformation(id: "1", name: "Super Saiyan", description: "Gains immense power.", photo: "url_to_photo", hero: HeroIDContainer(id: "1234")),
            Transformation(id: "2", name: "Kaio-Ken", description: "Increases power temporarily.", photo: "url_to_photo", hero: HeroIDContainer(id: "1234"))
        ]
        completion(.success(transformations)) // Return the dummy data as a success response
    }
}

// Mock for a failed scenario of GetAllTransformationsUseCase
private final class FailedGetAllTransformationsUseCaseMock: GetAllTransformationsUseContract {
    func execute(with id: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        // Return a failure response with an error message
        completion(.failure(APIErrorResponse.unknown("Error fetching transformations")))
    }
}

final class GetAllTransformationsUseCaseTests: XCTestCase {
    
    /// Test for the success scenario of fetching all transformations.
    func testGetAllTransformationsSuccess() {
        let expectation = self.expectation(description: "GetAllTransformationsSuccess")
        let useCaseMock = SuccessGetAllTransformationsUseCaseMock()
        
        // Execute the use case
        useCaseMock.execute(with: "1234") { result in
            switch result {
            case .success(let transformations):
                // Verify that we received the expected transformations
                XCTAssertEqual(transformations.count, 2) // Check that there are 2 transformations
                XCTAssertEqual(transformations[0].name, "Super Saiyan") // Verify the name of the first transformation
                XCTAssertEqual(transformations[1].name, "Kaio-Ken") // Verify the name of the second transformation
                expectation.fulfill() // Fulfill the expectation
            case .failure:
                XCTFail("Expected success but got failure") // Fail the test if we receive a failure
            }
        }
        
        waitForExpectations(timeout: 5) // Wait for the expectations to be fulfilled
    }
    
    /// Test for the failure scenario of fetching all transformations.
    func testGetAllTransformationsFailure() {
        let expectation = self.expectation(description: "GetAllTransformationsFailure")
        let useCaseMock = FailedGetAllTransformationsUseCaseMock()
        
        // Execute the use case
        useCaseMock.execute(with: "1234") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success") // Fail the test if we receive a success
            case .failure(let error):
                // Verify that the error is of the expected type
                XCTAssertTrue(error is APIErrorResponse)
                expectation.fulfill() // Fulfill the expectation
            }
        }
        
        waitForExpectations(timeout: 5) // Wait for the expectations to be fulfilled
    }
}
