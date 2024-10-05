import Foundation

/// Enum representing the possible states of the Transformation List ViewModel.
enum TransformationListState: Equatable {
    case loading
    case error(reason: String)
    case success
}

/// ViewModel responsible for managing the state and logic for the transformation list.
final class TransformationListViewModel {
    
    // MARK: - Properties
    let onStateChanged = Binding<TransformationListState>()
    private(set) var transformations: [Transformation] = []
    private let useCase: GetAllTransformationsUseContract
    private let heroId: String
    var onTransformationSelected: ((String, String) -> Void)? // Callback to handle the selection of a transformation
    
    // MARK: - Initializer
    /// Initializes the ViewModel with the necessary dependencies.
    /// - Parameters:
    ///   - useCase: The use case to retrieve transformations.
    ///   - heroId: The ID of the hero whose transformations are being displayed.
    init(useCase: GetAllTransformationsUseContract, heroId: String) {
        self.useCase = useCase
        self.heroId = heroId
    }
    
    // MARK: - Load Data
    /// Loads the list of transformations for the specified hero.
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase.execute(with: heroId) { [weak self] result in
            switch result {
            case .success(let transformations):
                self?.transformations = transformations
                self?.onStateChanged.update(newValue: .success)
            case .failure(let error):
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
    
    // MARK: - Select Transformation
    /// Handles the selection of a transformation by its index in the list.
    /// - Parameter index: The index of the selected transformation.
    func selectTransformation(at index: Int) {
        let transformation = transformations[index]
        onTransformationSelected?(heroId, transformation.id)
    }
}
