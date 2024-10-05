import Foundation

/// Protocol defining the contract for fetching all transformations related to a specific hero.
protocol GetAllTransformationsUseContract {
    
    /// Executes the use case to fetch all transformations for a given hero ID.
    /// - Parameters:
    ///   - id: The ID of the hero for which transformations are being fetched.
    ///   - completion: A closure to be called upon completion with a result that contains either an array of `Transformation` objects or an error.
    func execute(with id: String, completion: @escaping (Result<[Transformation], Error>) -> Void)
}

/// Final class implementing the `GetAllTransformationsUseContract` to handle fetching transformations for a hero.
final class GetAllTransformationsUseCase: GetAllTransformationsUseContract {
    
    /// Executes the request to fetch transformations for a given hero ID.
    /// - Parameters:
    ///   - id: The ID of the hero whose transformations are being requested.
    ///   - completion: A closure to be called with the result of the fetch operation, either with an array of `Transformation` objects or an error.
    func execute(with id: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        // Calls the API to fetch the transformations for the provided hero ID.
        GetTransformationsAPIRequest(id: id)
            .perform { result in
                do {
                    // Tries to get the transformations and pass them to the completion handler.
                    let transformations = try result.get()
                    completion(.success(transformations))
                } catch {
                    // If an error occurs, pass the error to the completion handler.
                    completion(.failure(error))
                    print("Error in GetAllTransformations API: \(error)")
                }
            }
    }
}
