@testable import SWPatterns
import XCTest

// Mock for a successful scenario of GetSingleTransformationUseCase
private final class SuccessGetSingleTransformationUseCaseMock: GetSingleTransformationUseContract {
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation?, Error>) -> Void) {
        // Create a dummy transformation to return in the success case
        let transformation = Transformation(id: transformationId, name: "Super Saiyan", description: "Gains immense power.", photo: "url_to_photo", hero: HeroIDContainer(id: heroId))
        completion(.success(transformation)) // Simulate a successful response
    }
}

// Mock for a failed scenario of GetSingleTransformationUseCase
private final class FailedGetSingleTransformationUseCaseMock: GetSingleTransformationUseContract {
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation?, Error>) -> Void) {
        // Simulate a failure response
        completion(.failure(APIErrorResponse.unknown("Error fetching transformation")))
    }
}

final class GetSingleTransformationsUseCaseTests: XCTestCase {
    
    /// Test for the success scenario of fetching a single transformation.
    func testGetSingleTransformationSuccess() {
        let expectation = self.expectation(description: "GetSingleTransformationSuccess")
        let useCaseMock = SuccessGetSingleTransformationUseCaseMock()
        
        // Execute the use case with the mock
        useCaseMock.execute(heroId: "1234", transformationId: "1") { result in
            switch result {
            case .success(let transformation):
                // Verify that we received the expected transformation
                XCTAssertNotNil(transformation) // Ensure the transformation is not nil
                XCTAssertEqual(transformation?.id, "1") // Verify the transformation ID
                XCTAssertEqual(transformation?.name, "Super Saiyan") // Verify the transformation name
                XCTAssertEqual(transformation?.description, "Gains immense power.") // Verify the transformation description
                expectation.fulfill() // Fulfill the expectation
            case .failure:
                XCTFail("Expected success but got failure") // Fail the test if we receive a failure
            }
        }
        
        waitForExpectations(timeout: 5) // Wait for the expectations to be fulfilled
    }
    
    /// Test for the failure scenario of fetching a single transformation.
    func testGetSingleTransformationFailure() {
        let expectation = self.expectation(description: "GetSingleTransformationFailure")
        let useCaseMock = FailedGetSingleTransformationUseCaseMock()
        
        // Execute the use case with the mock
        useCaseMock.execute(heroId: "1234", transformationId: "1") { result in
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
