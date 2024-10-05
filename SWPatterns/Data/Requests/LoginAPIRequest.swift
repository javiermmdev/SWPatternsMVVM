import Foundation

/// Struct representing the API request for user login.
/// Implements the `APIRequest` protocol with the response type as `Data`.
struct LoginAPIRequest: APIRequest {
    
    /// The expected response from the API, which is raw `Data`.
    typealias Response = Data
    
    /// The headers required for the login request.
    let headers: [String: String]
    
    /// The HTTP method for this request, set to POST.
    let method: HTTPMethod = .POST
    
    /// The API path for login.
    let path: String = "/api/auth/login"
    
    /// Initializes the login request with the provided credentials.
    /// - Parameter credentials: The user's login credentials, including username and password.
    init(credentials: Credentials) {
        // Encode the username and password in Base64 to form a Basic Authorization header.
        let loginData = Data(String(format: "%@:%@", credentials.username, credentials.password).utf8)
        let base64String = loginData.base64EncodedString()
        
        // Set the Authorization header for Basic authentication.
        headers = ["Authorization": "Basic \(base64String)"]
    }
}
