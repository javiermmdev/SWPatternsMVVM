import Foundation

/// Enum representing the possible states of the login process.
enum LoginState {
    case success
    case error(reason: String)
    case loading
}

/// View model responsible for handling the login logic and state updates.
final class LoginViewModel {
    
    /// A binding used to update the UI when the login state changes.
    let onStateChanged = Binding<LoginState>()
    
    /// The use case that performs the login operation.
    private let useCase: LoginUseCaseContract
    
    // MARK: - Initializer
    
    /// Initializes the view model with a provided use case.
    /// - Parameter useCase: The `LoginUseCaseContract` responsible for handling login operations.
    init(useCase: LoginUseCaseContract) {
        self.useCase = useCase
    }
    
    // MARK: - Sign-In Method
    
    /// Initiates the sign-in process with the provided username and password.
    /// - Parameters:
    ///   - username: The username entered by the user.
    ///   - password: The password entered by the user.
    func signIn(_ username: String?, _ password: String?) {
        onStateChanged.update(newValue: .loading)
        let credentials = Credentials(username: username ?? "", password: password ?? "")
        useCase.execute(credentials: credentials) { [weak self] result in
            do {
                try result.get()
                self?.onStateChanged.update(newValue: .success)
            } catch let error as LoginUseCaseError {
                self?.onStateChanged.update(newValue: .error(reason: error.reason))
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: "Something has happened"))
            }
        }
    }
}
