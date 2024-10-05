@testable import SWPatterns
import XCTest

final class SplashViewModelTests: XCTestCase {

    // Test case for successful loading of the splash screen
    func testLoadingStateTransition() {
        let expectation = self.expectation(description: "Loading completed") // Create an expectation for loading completion
        
        let sut = SplashViewModel() // Initialize the ViewModel
        
        // Bind the state changes to the expectation
        sut.onStateChanged.bind { state in
            if case .ready = state { // Check if the state is ready
                expectation.fulfill() // Fulfill the expectation when ready
            }
        }
        
        sut.load() // Start the loading process
        waitForExpectations(timeout: 5) // Wait for the expectation to be fulfilled
    }
    
}
