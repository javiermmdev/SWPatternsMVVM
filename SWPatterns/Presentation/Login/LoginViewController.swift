import UIKit

/// View controller responsible for managing the login screen.
final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    /// Text field for entering the username.
    @IBOutlet private weak var usernameField: UITextField!
    
    /// Text field for entering the password.
    @IBOutlet private weak var passwordField: UITextField!
    
    /// Spinner for indicating a loading state during sign-in.
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    /// Button to trigger the sign-in process.
    @IBOutlet private weak var signInButton: UIButton!
    
    /// Label for displaying error messages.
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Properties
    
    /// The view model associated with the login view controller.
    private let viewModel: LoginViewModel
    
    // MARK: - Initializer
    
    /// Initializes the view controller with a provided view model.
    /// - Parameter viewModel: The `LoginViewModel` used for handling login logic.
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    /// Called after the view has been loaded. Sets up bindings to the view model.
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - Actions
    
    /// Action triggered when the login button is tapped.
    /// - Parameter sender: The object that triggered the action (usually the button).
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        viewModel.signIn(usernameField.text, passwordField.text)
    }
    
    // MARK: - Bindings
    
    /// Binds the view model state changes to the UI updates.
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .success:
                self?.renderSuccess()
                self?.present(HeroesListBuilder().build(), animated: true)
            case .error(let reason):
                self?.renderError(reason)
            case .loading:
                self?.renderLoading()
            }
        }
    }
    
    // MARK: - State rendering functions
    
    /// Renders the success state by stopping the spinner and resetting the UI.
    private func renderSuccess() {
        signInButton.isHidden = false
        spinner.stopAnimating()
        errorLabel.isHidden = true
    }
    
    /// Renders the error state by showing the error message and stopping the spinner.
    /// - Parameter reason: The error message to display.
    private func renderError(_ reason: String) {
        signInButton.isHidden = false
        spinner.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = reason
    }
    
    /// Renders the loading state by hiding the sign-in button and starting the spinner.
    private func renderLoading() {
        signInButton.isHidden = true
        spinner.startAnimating()
        errorLabel.isHidden = true
    }
}

#Preview {
    LoginBuilder().build()
}
