import UIKit

/// The splash screen view controller that handles the app's initial loading state and transitions.
final class SplashViewController: UIViewController {
    
    /// UI component to display loading activity.
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    /// The view model managing the state of the splash screen.
    private let viewModel: SplashViewModel
    
    /// Initializes the view controller with a given view model.
    /// - Parameter viewModel: The view model responsible for controlling the splash screen state.
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self)))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Lifecycle method triggered when the view has loaded.
    /// Sets up the binding between the view model and UI, and starts the loading process.
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load()
    }
    
    /// Binds the view model's state changes to the UI.
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.setAnimation(true)
            case .ready:
                self?.setAnimation(false)
                self?.present(LoginBuilder().build(), animated: true)
            case .error:
                break
            }
        }
    }
    
    /// Controls the spinner's animation based on the loading state.
    /// - Parameter animating: A boolean value indicating whether to start or stop the spinner.
    private func setAnimation(_ animating: Bool) {
        switch spinner.isAnimating {
        case true where !animating:
            spinner.stopAnimating()
        case false where animating:
            spinner.startAnimating()
        default:
            break
        }
    }
}

#Preview {
    SplashBuilder().build()
}
