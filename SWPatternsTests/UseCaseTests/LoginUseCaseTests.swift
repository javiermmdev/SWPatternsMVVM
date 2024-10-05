@testable import SWPatterns
import XCTest

// Mock for API session to simulate API responses
final class APISessionMock: APISessionContract {
    let mockResponse: ((any APIRequest) -> Result<Data, any Error>)
    
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, any Error>) {
        self.mockResponse = mockResponse
    }
    
    // Simulates an API request and returns the mock response
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(mockResponse(apiRequest))
    }
}

// Dummy session data source for storing session tokens
final class DummySessionDataSource: SessionDataSourceContract {
    private(set) var session: Data?
        
    // Stores the session token
    func storeSession(_ session: Data) {
        self.session = session
    }
    
    // Returns nil since no session is stored initially
    func getSession() -> Data? { nil }
}

// Test case for the Login use case
final class LoginUseCaseTests: XCTestCase {
    
    /// Tests successful login and storing of the token.
    func testSuccessStoresToken() {
        let dataSource = DummySessionDataSource() // Create a dummy session data source
        let sut = LoginUseCase(dataSource: dataSource) // Create the LoginUseCase
        
        let expectation = self.expectation(description: "TestSuccess")
        let data = Data("hello-world".utf8) // Sample token data
        
        // Set the shared APISession to use the mock that returns success
        APISession.shared = APISessionMock { _ in .success(data) }
        
        // Execute the login with sample credentials
        sut.execute(credentials: Credentials(username: "a@b.es", password: "122345")) { result in
            guard case .success = result else {
                return // Fail if not successful
            }
            expectation.fulfill() // Fulfill the expectation on success
        }
        
        waitForExpectations(timeout: 5) // Wait for the expectation to be fulfilled
        XCTAssertEqual(dataSource.session, data) // Verify that the session token was stored correctly
    }
    
    /// Tests failure scenario where the token is not stored.
    func testFailureDoesNotStoreToken() {
        let dataSource = DummySessionDataSource() // Create a dummy session data source
        let sut = LoginUseCase(dataSource: dataSource) // Create the LoginUseCase
        
        let expectation = self.expectation(description: "TestFailure")
        
        // Set the shared APISession to use the mock that returns failure
        APISession.shared = APISessionMock { _ in .failure(APIErrorResponse.network("login-fail")) }
        
        // Execute the login with sample credentials
        sut.execute(credentials: Credentials(username: "a@b.es", password: "122345")) { result in
            guard case .failure = result else {
                return // Fail if not a failure
            }
            expectation.fulfill() // Fulfill the expectation on failure
        }
        
        waitForExpectations(timeout: 5) // Wait for the expectation to be fulfilled
        XCTAssertNil(dataSource.session) // Verify that no session token was stored
    }
}
