import UIKit

/// Builder class responsible for creating the Login view controller.
final class LoginBuilder {
    
    // MARK: - Methods
    
    /// Builds and returns the `LoginViewController`.
    /// - Returns: A fully configured `LoginViewController` with its ViewModel.
    func build() -> UIViewController {
        // Instantiate the login use case.
        let loginUseCase = LoginUseCase()
        
        // Create the view model and pass the use case.
        let viewModel = LoginViewModel(useCase: loginUseCase)
        
        // Initialize the view controller with the view model.
        let viewController = LoginViewController(viewModel: viewModel)
        
        // Set the modal presentation style to full screen.
        viewController.modalPresentationStyle = .fullScreen
        
        return viewController
    }
}
