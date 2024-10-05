@testable import SWPatterns
import XCTest

final class GetAllHeroesUseCaseTests: XCTestCase {
    
    /// Test for the success scenario of fetching all heroes.
    func testGetAllHeroesSuccess() {
        // Prepare the expected hero data in JSON format.
        let heroesData = """
        [{
            "id": "1234",
            "name": "Goku",
            "description": "A powerful Saiyan",
            "photo": "",
            "favorite": true
        },
        {
            "id": "5678",
            "name": "Vegeta",
            "description": "The Prince of all Saiyans",
            "photo": "",
            "favorite": true
        },
        {
            "id": "9101",
            "name": "Gohan",
            "description": "Son of Goku",
            "photo": "",
            "favorite": false
        }]
        """.data(using: .utf8)!
        
        // Create an API session mock that will return the hero data.
        let useCaseMock = APISessionMock { _ in
            .success(heroesData)
        }
        
        APISession.shared = useCaseMock // Assign the mock to the shared session.
        
        // Create the use case instance.
        let sut = GetAllHeroesUseCase()
        let expectation = self.expectation(description: "GetAllHeroesSuccess")
        
        // Execute the use case.
        sut.execute { result in
            switch result {
            case .success(let heroes):
                // Verify that we received the expected heroes.
                XCTAssertEqual(heroes.count, 3) // Check that there are 3 heroes.
                XCTAssertEqual(heroes[0].name, "Goku")
                XCTAssertEqual(heroes[1].name, "Vegeta")
                XCTAssertEqual(heroes[2].name, "Gohan")
                expectation.fulfill() // Fulfill the expectation.
            case .failure:
                XCTFail("Expected success but got failure") // Fail the test if we receive a failure.
            }
        }
        
        waitForExpectations(timeout: 5) // Wait for the expectations to be fulfilled.
    }
    
    /// Test for the failure scenario of fetching all heroes.
    func testGetAllHeroesFailure() {
        // Create an API session mock that will return an error.
        let useCaseMock = APISessionMock { _ in
            .failure(APIErrorResponse.network("Error fetching heroes"))
        }
        
        APISession.shared = useCaseMock // Assign the mock to the shared session.
        
        // Create the use case instance.
        let sut = GetAllHeroesUseCase()
        let expectation = self.expectation(description: "GetAllHeroesFailure")
        
        // Execute the use case.
        sut.execute { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success") // Fail the test if we receive a success.
            case .failure(let error):
                // Verify that the error is of the expected type.
                XCTAssertTrue(error is APIErrorResponse)
                expectation.fulfill() // Fulfill the expectation.
            }
        }
        
        waitForExpectations(timeout: 5) // Wait for the expectations to be fulfilled.
    }
}
