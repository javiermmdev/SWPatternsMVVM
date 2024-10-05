import UIKit

/// The scene delegate class responsible for managing the app's window and its life cycle.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties
    /// The main window of the application.
    var window: UIWindow?

    // MARK: - Scene Life Cycle
    /// Called when the scene is about to connect to the app.
    /// - Parameters:
    ///   - scene: The scene object containing the UI for the app.
    ///   - session: The session associated with the scene.
    ///   - connectionOptions: Options for configuring the scene's initial state.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure that the scene is of type UIWindowScene before proceeding.
        guard let scene = (scene as? UIWindowScene) else { return }
        
        // Set up the main window with the splash screen as the root view controller.
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = SplashBuilder().build()
        self.window?.makeKeyAndVisible()
    }
}
