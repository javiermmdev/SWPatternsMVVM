import Foundation

/// Enum representing the possible states of the Transformation Detail view.
enum TransformationDetailState: Equatable {
    case loading
    case error(reason: String)
    case success
}

/// ViewModel responsible for handling the transformation details.
final class TransformationDetailViewModel {
    
    /// Binding for notifying the view of state changes.
    let onStateChanged = Binding<TransformationDetailState>()
    
    /// The loaded transformation object.
    private(set) var transformation: Transformation?
    
    /// Use case to fetch a single transformation.
    private let useCase: GetSingleTransformationUseContract
    
    /// The ID of the hero associated with the transformation.
    private let heroId: String
    
    /// The ID of the transformation.
    private let transformationId: String

    /// Initializes the ViewModel with necessary dependencies.
    ///
    /// - Parameters:
    ///   - useCase: The use case to retrieve a single transformation.
    ///   - heroId: The ID of the hero.
    ///   - transformationId: The ID of the transformation.
    init(useCase: GetSingleTransformationUseContract, heroId: String, transformationId: String) {
        self.useCase = useCase
        self.heroId = heroId
        self.transformationId = transformationId
    }
    
    /// Loads the transformation details from the API.
    func load() {
        // Update the state to `loading`.
        onStateChanged.update(newValue: .loading)
        
        // Execute the use case to fetch the specific transformation by heroId and transformationId.
        useCase.execute(heroId: heroId, transformationId: transformationId) { [weak self] result in
            switch result {
            case .success(let transformation):
                // Set the transformation and notify success.
                self?.transformation = transformation
                self?.onStateChanged.update(newValue: .success)
            case .failure(let error):
                // Notify of an error with the error message.
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
