import UIKit

/// Builder class responsible for constructing the splash screen view controller.
final class SplashBuilder {
    
    /// Builds and returns the splash screen view controller.
    /// - Returns: A configured `SplashViewController` with its associated view model.
    func build() -> UIViewController {
        let viewModel = SplashViewModel()
        return SplashViewController(viewModel: viewModel)
    }
}
