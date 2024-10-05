import Foundation

/// Protocol that marks an API interceptor. Used as a base for different types of interceptors.
protocol APIInterceptor { }

/// Protocol for intercepting and modifying an API request before it is sent.
/// - Parameters:
///   - request: The `URLRequest` that will be intercepted and potentially modified.
protocol APIRequestInterceptor: APIInterceptor {
    func intercept(request: inout URLRequest)
}

/// Intercepts API requests to add authentication headers, such as Bearer tokens.
final class AuthenticationRequestInterceptor: APIRequestInterceptor {
    private let dataSource: SessionDataSourceContract
    
    /// Initializes the interceptor with a session data source, which provides the session token.
    /// - Parameter dataSource: A `SessionDataSourceContract` that stores and retrieves session tokens.
    init(dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    
    /// Intercepts the given request and adds an "Authorization" header if a valid session token exists.
    /// - Parameter request: The `URLRequest` to modify, adding an authentication token if available.
    func intercept(request: inout URLRequest) {
        guard let session = dataSource.getSession() else {
            return
        }
        request.setValue("Bearer \(String(decoding: session, as: UTF8.self))", forHTTPHeaderField: "Authorization")
    }
}
