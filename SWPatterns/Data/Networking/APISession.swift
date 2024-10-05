import Foundation

/// Protocol that defines the contract for API session handling.
/// - A generic request method is required that accepts an APIRequest and returns the result as a Data object or an error.
protocol APISessionContract {
    /// Makes a request with the provided API request and returns a result.
    /// - Parameters:
    ///   - apiRequest: The request conforming to `APIRequest` to be executed.
    ///   - completion: Closure that is called with the result, either data or an error.
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

/// Struct responsible for managing API sessions.
/// It handles making network requests, applying interceptors, and returning the results.
struct APISession: APISessionContract {
    
    /// Shared singleton instance of `APISessionContract` for use throughout the application.
    static var shared: APISessionContract = APISession()
    
    /// URLSession used for network communication.
    private let session = URLSession(configuration: .default)
    
    /// An array of interceptors that modify the request before it's sent.
    private let requestInterceptors: [APIRequestInterceptor]
    
    /// Initializes the `APISession` with optional request interceptors.
    /// - Parameter requestInterceptors: Array of interceptors that can modify the request. Defaults to `AuthenticationRequestInterceptor`.
    init(requestInterceptors: [APIRequestInterceptor] = [AuthenticationRequestInterceptor()]) {
        self.requestInterceptors = requestInterceptors
    }
    
    /// Executes the provided API request and returns the result asynchronously.
    /// - Parameters:
    ///   - apiRequest: The request conforming to `APIRequest` that will be executed.
    ///   - completion: Closure that is called with the result, either Data on success or an Error on failure.
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            // Generate the URLRequest from the APIRequest
            var request = try apiRequest.getRequest()
            
            // Apply all interceptors to modify the request before sending
            requestInterceptors.forEach { $0.intercept(request: &request) }
            
            // Perform the network request using URLSession
            session.dataTask(with: request) { data, response, error in
                // Check for network error
                if let error {
                    return completion(.failure(error))
                }
                
                // Ensure the response is successful with a 200 status code
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return completion(.failure(APIErrorResponse.network(apiRequest.path)))
                }
                
                // Return the result as Data or an empty Data object if no data was returned
                return completion(.success(data ?? Data()))
            }.resume() // Start the network request
        } catch {
            // Handle errors thrown during request preparation
            completion(.failure(error))
        }
    }
}
