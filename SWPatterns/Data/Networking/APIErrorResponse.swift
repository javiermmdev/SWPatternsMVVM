import Foundation

/// Represents an error response from an API request, including details about the URL, status code, and message.
/// - Parameters:
///   - url: The URL that caused the error.
///   - statusCode: The HTTP status code of the error.
///   - data: Optional data received from the server, if available.
///   - message: A descriptive message for the error.
struct APIErrorResponse: Error, Equatable {
    let url: String
    let statusCode: Int
    let data: Data?
    let message: String
    
    /// Initializes a new APIErrorResponse.
    /// - Parameters:
    ///   - url: The URL that caused the error.
    ///   - statusCode: The HTTP status code of the error.
    ///   - data: Optional response data.
    ///   - message: A descriptive error message.
    init(url: String, statusCode: Int, data: Data? = nil, message: String) {
        self.url = url
        self.statusCode = statusCode
        self.data = data
        self.message = message
    }
}

// MARK: - Predefined API Error Responses
extension APIErrorResponse {
    
    /// Creates a predefined API error for network connection issues.
    /// - Parameter url: The URL that caused the network issue.
    /// - Returns: An `APIErrorResponse` indicating a network error.
    static func network(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -1, message: "Network connection error")
    }
    
    /// Creates a predefined API error for data parsing failures.
    /// - Parameter url: The URL that caused the parsing issue.
    /// - Returns: An `APIErrorResponse` indicating a data parsing error.
    static func parseData(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -2, message: "Cannot Parse data")
    }
    
    /// Creates a predefined API error for unknown issues.
    /// - Parameter url: The URL that caused the unknown error.
    /// - Returns: An `APIErrorResponse` indicating an unknown error.
    static func unknown(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -3, message: "Unknown error")
    }
    
    /// Creates a predefined API error for empty responses.
    /// - Parameter url: The URL that returned an empty response.
    /// - Returns: An `APIErrorResponse` indicating an empty response error.
    static func empty(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -4, message: "Empty response")
    }
    
    /// Creates a predefined API error for malformed URLs.
    /// - Parameter url: The URL that could not be generated.
    /// - Returns: An `APIErrorResponse` indicating a malformed URL error.
    static func malformedURL(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -5, message: "Can't generate the Url")
    }
}
