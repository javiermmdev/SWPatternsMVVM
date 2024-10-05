import UIKit

/// Builder class responsible for constructing the HeroesDetailViewController.
final class HeroesDetailBuilder {
    
    /// Builds and returns a fully initialized HeroesDetailViewController.
    /// - Parameter heroName: The name of the hero to be displayed in detail.
    /// - Returns: A UIViewController instance configured to show hero details.
    func build(heroName: String) -> UIViewController {
        
        // Initialize use cases for fetching hero details and transformations.
        let heroUseCase = GetSingleHeroes()
        let transformationsUseCase = GetAllTransformationsUseCase()
        
        // Initialize the ViewModel with the necessary use cases and hero name.
        let viewModel = HeroesDetailViewModel(
            heroUseCase: heroUseCase,
            transformationsUseCase: transformationsUseCase,
            heroName: heroName
        )
        
        // Initialize the HeroesDetailViewController with the ViewModel.
        let viewController = HeroesDetailViewController(viewModel: viewModel)
        
        // Return the fully constructed view controller.
        return viewController
    }
}
