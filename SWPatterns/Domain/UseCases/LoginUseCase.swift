import Foundation

/// Protocol for the Login use case contract.
protocol LoginUseCaseContract {
    
    /// Executes the login operation using the provided credentials.
    /// - Parameters:
    ///   - credentials: User credentials including username and password.
    ///   - completion: A closure that handles either a successful login or a `LoginUseCaseError`.
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void)
}

/// Use case for performing login and storing the session.
final class LoginUseCase: LoginUseCaseContract {
    
    /// Data source for storing session-related data.
    private let dataSource: SessionDataSourceContract
    
    /// Initializes the use case with an optional session data source.
    /// - Parameter dataSource: A data source to manage session storage, defaults to `SessionDataSource`.
    init(dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    
    /// Executes the login process with validation for username and password.
    /// - Parameters:
    ///   - credentials: The user's credentials for login.
    ///   - completion: A closure that provides either a success with an empty response or a `LoginUseCaseError`.
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void) {
        // Validate the username before proceeding.
        guard validateUsername(credentials.username) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid username")))
        }
        // Validate the password before proceeding.
        guard validatePassword(credentials.password) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid password")))
        }
        
        // Perform the login request to the API.
        LoginAPIRequest(credentials: credentials)
            .perform { [weak self] result in
                switch result {
                case .success(let token):
                    // Store the session token upon successful login.
                    self?.dataSource.storeSession(token)
                    completion(.success(()))
                case .failure:
                    // Return an error if login fails.
                    completion(.failure(LoginUseCaseError(reason: "Email/Password invalid")))
                }
            }
    }
    
    /// Validates the username by checking if it contains "@" and is not empty.
    /// - Parameter username: The username to validate.
    /// - Returns: `true` if the username is valid, otherwise `false`.
    private func validateUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty
    }
    
    /// Validates the password by ensuring it meets the minimum length requirement.
    /// - Parameter password: The password to validate.
    /// - Returns: `true` if the password is valid, otherwise `false`.
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 4
    }
}

/// Struct representing a login use case error.
struct LoginUseCaseError: Error {
    /// The reason for the login failure.
    let reason: String
}
