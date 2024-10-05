import Foundation

/// Represents the different states of the splash screen.
enum SplashState {
    case loading
    case error
    case ready
}

/// View model responsible for managing the state of the splash screen.
class SplashViewModel {
    
    /// Binding used to notify the view controller about state changes.
    var onStateChanged = Binding<SplashState>()
    
    /// Initiates the loading process for the splash screen.
    /// Simulates a network or resource loading by triggering the `loading` state,
    /// followed by the `ready` state after a delay of 3 seconds.
    func load() {
        onStateChanged.update(newValue: .loading)
        
        /// Simulates asynchronous loading, such as a network call.
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.onStateChanged.update(newValue: .ready)
        }
    }
}
