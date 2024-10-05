import Foundation

/// Enum representing the various states of the Heroes list.
enum HeroesListState: Equatable {
    case loading
    case error(reason: String)
    case success
}

/// ViewModel responsible for handling the logic and data of the Heroes list.
final class HeroesListViewModel {
    
    // MARK: - Properties
    
    /// Binding to observe changes in the list's state (loading, error, success).
    let onStateChanged = Binding<HeroesListState>()
    
    /// Array to store the loaded heroes.
    private(set) var heroes: [Hero] = []
    
    /// Use case for retrieving all heroes.
    private let useCase: GetAllHeroesUseCaseContract
    
    /// Closure that is executed when a hero is selected.
    var onHeroSelected: ((Hero) -> Void)?
    
    // MARK: - Initializer
    
    /// Initializes the `HeroesListViewModel` with a use case.
    /// - Parameter useCase: The use case that will fetch the heroes data.
    init(useCase: GetAllHeroesUseCaseContract) {
        self.useCase = useCase
    }
    
    // MARK: - Methods
    
    /// Loads the heroes list by triggering the use case and updating the state.
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase.execute { [weak self] result in
            do {
                // On success, update the heroes array and the state to success.
                self?.heroes = try result.get()
                self?.onStateChanged.update(newValue: .success)
            } catch {
                // On failure, update the state with the error message.
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
    
    /// Selects a hero from the list based on the provided index.
    /// - Parameter index: The index of the selected hero in the array.
    func selectHero(at index: Int) {
        let selectedHero = heroes[index]
        onHeroSelected?(selectedHero)
    }
}
