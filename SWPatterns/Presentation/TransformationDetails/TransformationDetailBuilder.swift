import UIKit

/// Builder responsible for constructing the `TransformationDetailViewController`.
final class TransformationDetailBuilder {
    
    /// Builds the `TransformationDetailViewController` with the provided `heroId` and `transformationId`.
    ///
    /// - Parameters:
    ///   - heroId: The ID of the hero.
    ///   - transformationId: The ID of the transformation.
    /// - Returns: A fully initialized `TransformationDetailViewController`.
    func build(heroId: String, transformationId: String) -> UIViewController {
        
        // Create the use case responsible for fetching a single transformation.
        let useCase = GetSingleTransformationUseCase()
        
        // Initialize the ViewModel with the use case, hero ID, and transformation ID.
        let viewModel = TransformationDetailViewModel(useCase: useCase, heroId: heroId, transformationId: transformationId)
        
        // Initialize the ViewController and inject the ViewModel.
        let viewController = TransformationDetailViewController(viewModel: viewModel)
        
        return viewController
    }
}
