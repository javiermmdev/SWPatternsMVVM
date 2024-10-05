import Foundation

/// Struct representing the API request to fetch a list of transformations for a hero.
/// Implements the `APIRequest` protocol with the response type as an array of `Transformation`.
struct GetTransformationsAPIRequest: APIRequest {
    
    /// The expected response from the API, an array of `Transformation`.
    typealias Response = [Transformation]
    
    /// The API path for fetching transformations.
    let path: String = "/api/heros/tranformations"
    
    /// The HTTP method for this request.
    let method: HTTPMethod = .POST
    
    /// The request body that will be sent in the API call.
    let body: (any Encodable)?
    
    /// Initializes the request with an optional hero ID.
    /// - Parameter id: The ID of the hero to fetch transformations for, defaults to "any" if `nil`.
    init(id: String?) {
        body = RequestEntity(id: id ?? "any")
    }
}

private extension GetTransformationsAPIRequest {
    
    /// Private struct used as the body of the request.
    /// Contains the hero ID to fetch transformations for.
    struct RequestEntity: Encodable {
        let id: String
    }
}
