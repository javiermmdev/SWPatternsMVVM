import Foundation

/// Protocol defining the contract for the use case that retrieves all heroes.
protocol GetAllHeroesUseCaseContract {
    
    /// Executes the use case to fetch all heroes.
    /// - Parameter completion: A closure to be called upon completion with a result that contains either an array of `Hero` objects or an error.
    func execute(completion: @escaping (Result<[Hero], Error>) -> Void)
}

/// Final class implementing the `GetAllHeroesUseCaseContract` protocol to fetch all heroes.
final class GetAllHeroesUseCase: GetAllHeroesUseCaseContract {
    
    /// Executes the request to fetch all heroes.
    /// - Parameter completion: A closure to be called with the result of the fetch operation, either with an array of `Hero` objects or an error.
    func execute(completion: @escaping (Result<[Hero], any Error>) -> Void) {
        GetHeroesAPIRequest(name: "") // Sending a request with an empty name to get all heroes.
            .perform { result in
                do {
                    // On success, pass the array of heroes to the completion handler.
                    try completion(.success(result.get()))
                } catch {
                    // On error, pass the error to the completion handler.
                    completion(.failure(error))
                }
            }
    }
}
