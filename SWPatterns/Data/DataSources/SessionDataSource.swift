import Foundation

/// Stores or retrieves session data for user authentication or session management.
/// - Parameters:
///   - session: The session data to be stored as a `Data` type.
protocol SessionDataSourceContract {
    /// Stores the session data.
    /// - Parameter session: The session data to be stored.
    func storeSession(_ session: Data)
    
    /// Retrieves the stored session data.
    /// - Returns: The stored session data, or nil if none is available.
    func getSession() -> Data?
}

// MARK: - SessionDataSource
// Manages the session data through static properties to ensure consistency.
final class SessionDataSource: SessionDataSourceContract {
    
    // Static variable to store the session token
    private static var token: Data?
    
    /// Stores the session data in a static variable.
    /// - Parameter session: The session data to be stored.
    func storeSession(_ session: Data) {
        SessionDataSource.token = session
    }
    
    /// Retrieves the stored session data from the static variable.
    /// - Returns: The stored session data, or nil if none is stored.
    func getSession() -> Data? {
        return SessionDataSource.token
    }
}
