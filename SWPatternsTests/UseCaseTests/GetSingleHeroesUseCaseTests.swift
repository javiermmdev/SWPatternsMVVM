@testable import SWPatterns
import XCTest

// Mock for a successful scenario of GetSingleHeroesUseCase
private final class SuccessGetSingleHeroesUseCaseMock: GetSingleHeroesUseCaseContract {
    func execute(with name: String, completion: @escaping (Result<Hero?, Error>) -> Void) {
        // Simulate a successful response with a hero object
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
        // Simulate a failure response with an error message
        completion(.failure(APIErrorResponse.unknown("Error fetching hero")))
    }
}

final class GetSingleHeroesUseCaseTests: XCTestCase {
    
    /// Test for the success scenario of fetching a single hero.
    func testGetSingleHeroSuccess() {
        let expectation = self.expectation(description: "GetSingleHeroSuccess")
        let useCaseMock = SuccessGetSingleHeroesUseCaseMock()
        
        // Execute the use case with the mock
        useCaseMock.execute(with: "Goku") { result in
            switch result {
            case .success(let hero):
                // Verify that we received the expected hero
                XCTAssertNotNil(hero) // Ensure the hero is not nil
                XCTAssertEqual(hero?.id, "1234") // Verify the hero ID
                XCTAssertEqual(hero?.name, "Goku") // Verify the hero name
                XCTAssertEqual(hero?.description, "A powerful Saiyan") // Verify the hero description
                expectation.fulfill() // Fulfill the expectation
            case .failure:
                XCTFail("Expected success but got failure") // Fail the test if we receive a failure
            }
        }
        
        waitForExpectations(timeout: 5) // Wait for the expectations to be fulfilled
    }
    
    /// Test for the failure scenario of fetching a single hero.
    func testGetSingleHeroFailure() {
        let expectation = self.expectation(description: "GetSingleHeroFailure")
        let useCaseMock = FailedGetSingleHeroesUseCaseMock()
        
        // Execute the use case with the mock
        useCaseMock.execute(with: "Goku") { result in
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
