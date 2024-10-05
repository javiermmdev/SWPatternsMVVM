import UIKit

/// Builder class responsible for constructing the `TransformationListViewController`.
final class TransformationListBuilder {
    
    /// Builds and returns a `TransformationListViewController` initialized with the given hero ID.
    ///
    /// - Parameter heroId: The ID of the hero for which the transformations will be fetched.
    /// - Returns: A fully initialized `TransformationListViewController`.
    func build(heroId: String) -> UIViewController {
        let useCase = GetAllTransformationsUseCase()
        let viewModel = TransformationListViewModel(useCase: useCase, heroId: heroId)
        let viewController = TransformationListViewController(viewModel: viewModel)
        
        return viewController
    }
}
