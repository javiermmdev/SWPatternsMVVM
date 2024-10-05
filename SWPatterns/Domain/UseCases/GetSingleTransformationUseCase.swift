import Foundation

/// Protocol to fetch a specific transformation by the hero ID and transformation ID.
protocol GetSingleTransformationUseContract {
    
    /// Executes the use case to fetch a specific transformation.
    /// - Parameters:
    ///   - heroId: The ID of the hero whose transformations are being queried.
    ///   - transformationId: The ID of the specific transformation to be fetched.
    ///   - completion: A closure to be called with either the transformation found or an error.
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation?, Error>) -> Void)
}

/// Use case implementation to fetch a specific transformation by its ID.
final class GetSingleTransformationUseCase: GetSingleTransformationUseContract {
    
    /// Executes the API request to fetch transformations for a given hero and filter them by the transformation ID.
    /// - Parameters:
    ///   - heroId: The ID of the hero whose transformations are being fetched.
    ///   - transformationId: The ID of the specific transformation to retrieve.
    ///   - completion: A closure to be called with either the specific transformation or an error.
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation?, Error>) -> Void) {
        // Calls the API to get the list of transformations for the given hero ID.
        GetTransformationsAPIRequest(id: heroId)
            .perform { result in
                do {
                    // Gets the list of transformations from the API response.
                    let transformations = try result.get()
                    // Filters the transformations to find the one matching the provided transformation ID.
                    let filteredTransformation = transformations.first { $0.id == transformationId }
                    // Calls the completion handler with the found transformation or nil if not found.
                    completion(.success(filteredTransformation))
                } catch {
                    // In case of failure, passes the error to the completion handler.
                    completion(.failure(error))
                    print("Error in GetSingleTransformation API: \(error)")
                }
            }
    }
}
