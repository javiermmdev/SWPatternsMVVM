import Foundation

/// Protocol defining the contract for fetching a single hero by their name.
protocol GetSingleHeroesUseCaseContract {
    
    /// Executes the use case to fetch a hero by their name.
    /// - Parameters:
    ///   - name: The name of the hero being fetched.
    ///   - completion: A closure to be called with the result containing either a `Hero?` object or an error.
    func execute(with name: String, completion: @escaping (Result<Hero?, Error>) -> Void)
}

/// Final class that implements the `GetSingleHeroesUseCaseContract` to fetch a single hero by their name.
final class GetSingleHeroes: GetSingleHeroesUseCaseContract {
    
    /// Executes the API request to fetch the hero by name.
    /// - Parameters:
    ///   - name: The name of the hero to be fetched.
    ///   - completion: A closure to be called with either the `Hero?` found or an error.
    func execute(with name: String, completion: @escaping (Result<Hero?, Error>) -> Void) {
        // Calls the API to get the list of heroes.
        GetHeroesAPIRequest(name: name)
            .perform { result in
                switch result {
                case .success(let heroes):
                    // Filters the heroes to find the one matching the provided name, ignoring case.
                    let filteredHero = heroes.first { $0.name.lowercased() == name.lowercased() }
                    // Calls the completion handler with the found hero or nil if not found.
                    completion(.success(filteredHero))
                case .failure(let error):
                    // In case of failure, passes the error to the completion handler.
                    completion(.failure(error))
                }
            }
    }
}
