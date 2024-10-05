import Foundation

/// A class that allows a property to be observed for changes and executes a closure when updated.
final class Binding<State> {
    
    // MARK: - Typealias
    /// A closure type that takes a state as its parameter.
    typealias Completion = (State) -> Void
    
    // MARK: - Properties
    /// A closure that gets executed whenever the state is updated.
    var completion: Completion?
    
    // MARK: - Binding Method
    /// Binds a closure to be executed whenever the state changes.
    /// - Parameter completion: The closure to be executed when the state changes.
    func bind(completion: @escaping Completion) {
        self.completion = completion
    }
    
    // MARK: - Update Method
    /// Updates the state and triggers the bound closure on the main thread.
    /// - Parameter newValue: The new state value that triggers the closure.
    func update(newValue: State) {
        DispatchQueue.main.async { [weak self] in
            self?.completion?(newValue)
        }
    }
}
