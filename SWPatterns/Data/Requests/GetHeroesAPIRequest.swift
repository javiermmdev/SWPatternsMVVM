import Foundation

/// Struct representing the API request to fetch a list of heroes.
/// Implements the `APIRequest` protocol with the response type as an array of `Hero`.
struct GetHeroesAPIRequest: APIRequest {
    
    /// The expected response from the API, an array of `Hero`.
    typealias Response = [Hero]
    
    /// The API path for fetching heroes.
    let path: String = "/api/heros/all"
    
    /// The HTTP method for this request.
    let method: HTTPMethod = .POST
    
    /// The request body that will be sent in the API call.
    let body: (any Encodable)?
    
    /// Initializes the request with an optional hero name.
    /// - Parameter name: The name of the hero to search for, defaults to an empty string if `nil`.
    init(name: String?) {
        body = RequestEntity(name: name ?? "")
    }
}

private extension GetHeroesAPIRequest {
    
    /// Private struct used as the body of the request.
    /// Contains the name of the hero to fetch from the API.
    struct RequestEntity: Encodable {
        let name: String
    }
}
