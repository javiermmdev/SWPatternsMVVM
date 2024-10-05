import Foundation

/// Enum representing the different states of the HeroesDetail screen
enum HeroesDetailState: Equatable {
    case loading
    case error(reason: String)
    case success
}

/// ViewModel responsible for handling the hero's details and transformations
final class HeroesDetailViewModel {
    
    /// Binding property to observe state changes in the ViewModel
    let onStateChanged = Binding<HeroesDetailState>()
    
    /// The hero details to be displayed
    private(set) var hero: Hero?
    
    /// Boolean flag to check if the hero has transformations
    private(set) var hasTransformations: Bool = false
    
    /// Use case for fetching a single hero by name
    private let heroUseCase: GetSingleHeroesUseCaseContract
    
    /// Use case for fetching all transformations for a hero
    private let transformationsUseCase: GetAllTransformationsUseContract
    
    /// The name of the hero to fetch
    private let heroName: String

    // MARK: - Initializer
    /// Initializes the ViewModel with required use cases and hero name
    /// - Parameters:
    ///   - heroUseCase: The use case to fetch hero details
    ///   - transformationsUseCase: The use case to fetch hero transformations
    ///   - heroName: The name of the hero
    init(heroUseCase: GetSingleHeroesUseCaseContract, transformationsUseCase: GetAllTransformationsUseContract, heroName: String) {
        self.heroUseCase = heroUseCase
        self.transformationsUseCase = transformationsUseCase
        self.heroName = heroName
    }
    
    // MARK: - Methods
    
    /// Loads the hero details and checks for transformations
    func load() {
        onStateChanged.update(newValue: .loading)
        
        // Fetch hero by name
        heroUseCase.execute(with: heroName) { [weak self] result in
            switch result {
            case .success(let hero):
                self?.hero = hero
                
                // Safely unpack the hero's ID and check for transformations
                guard let heroId = hero?.id else {
                    self?.onStateChanged.update(newValue: .error(reason: "Hero ID is missing"))
                    return
                }
                
                // Load hero's transformations
                self?.loadHeroTransformations(heroId: heroId)
            case .failure(let error):
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
    
    /// Loads the hero's transformations
    /// - Parameter heroId: The ID of the hero whose transformations are to be loaded
    private func loadHeroTransformations(heroId: String) {
        transformationsUseCase.execute(with: heroId) { [weak self] result in
            switch result {
            case .success(let transformations):
                // Update flag to indicate if the hero has transformations
                self?.hasTransformations = !transformations.isEmpty
                
                // Notify success state
                self?.onStateChanged.update(newValue: .success)
                
                // Log a message if no transformations are found
                if transformations.isEmpty {
                    print("Hero has no transformations")
                }
            case .failure(let error):
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
