import Foundation

/// Enum representing HTTP methods for API requests.
enum HTTPMethod: String {
    case GET, POST, PUT, UPDATE, HEAD, PATCH, DELETE, OPTIONS
}

/// Protocol defining the structure of an API request, including host, method, body, path, headers, and query parameters.
/// - Associatedtype Response: The expected response type, which must conform to Decodable.
/// - APIRequestResponse: A result type wrapping either the decoded response or an APIErrorResponse.
/// - APIRequestCompletion: A closure that accepts the APIRequestResponse upon request completion.
protocol APIRequest {
    var host: String { get }
    var method: HTTPMethod { get }
    var body: Encodable? { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
    
    associatedtype Response: Decodable
    typealias APIRequestResponse = Result<Response, APIErrorResponse>
    typealias APIRequestCompletion = (APIRequestResponse) -> Void
}

extension APIRequest {
    
    /// Default host for the API.
    var host: String { "dragonball.keepcoding.education" }
    
    var queryParameters: [String: String] { [:] }
    var headers: [String: String] { [:] }
    var body: Encodable? { nil }
    
    /// Creates and returns a `URLRequest` from the provided components such as path, method, and body.
    /// - Throws: An `APIErrorResponse` if URL creation fails.
    /// - Returns: A configured `URLRequest` ready for execution.
    func getRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        // Add query parameters if any exist
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = components.url else {
            throw APIErrorResponse.malformedURL(path)
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        // Set the request body for non-GET requests
        if method != .GET, let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        // Set the default headers and merge with any additional headers
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ].merging(headers) { $1 }
        
        request.timeoutInterval = 10
        return request
    }
}

// MARK: - Execution
extension APIRequest {
    
    /// Executes the API request using a session and handles the response.
    /// - Parameters:
    ///   - session: An `APISessionContract` to manage the request (defaults to `APISession.shared`).
    ///   - completion: A closure called when the request completes, passing the decoded response or an error.
    func perform(session: APISessionContract = APISession.shared, completion: @escaping APIRequestCompletion) {
        session.request(apiRequest: self) { result in
            do {
                let data = try result.get()
                
                // Handle different response types (Void or Data)
                if Response.self == Void.self {
                    return completion(.success(() as! Response))
                } else if Response.self == Data.self {
                    return completion(.success(data as! Response))
                }

                // Decode the expected response
                return try completion(.success(JSONDecoder().decode(Response.self, from: data)))
                
            } catch let error as APIErrorResponse {
                completion(.failure(error))
            } catch {
                completion(.failure(APIErrorResponse.unknown(path)))
            }
        }
    }
}
