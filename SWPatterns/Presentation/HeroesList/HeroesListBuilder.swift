import UIKit

/// Builder class responsible for constructing the `HeroesListViewController` and setting up its dependencies.
final class HeroesListBuilder {
    
    /// Builds and returns the `UINavigationController` containing `HeroesListViewController`.
    /// - Returns: A fully set up `UINavigationController` with `HeroesListViewController` as the root view controller.
    func build() -> UIViewController {
        let useCase = GetAllHeroesUseCase()  // Use case to fetch all heroes
        let viewModel = HeroesListViewModel(useCase: useCase)  // ViewModel that handles business logic for the list of heroes
        let viewController = HeroesListViewController(viewModel: viewModel)  // ViewController to display the heroes list
        
        // Embeds the `HeroesListViewController` in a navigation controller
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen  // Ensures the navigation controller is presented fullscreen
        
        return navigationController  // Returns the navigation controller to be presented
    }
}
