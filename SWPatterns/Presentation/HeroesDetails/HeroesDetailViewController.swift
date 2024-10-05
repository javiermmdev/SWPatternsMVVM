import UIKit

/// ViewController responsible for displaying hero details.
final class HeroesDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var heroImageView: AsyncImageView!
    @IBOutlet weak var nameHero: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var transformationsButton: UIButton!
    
    // ViewModel for the hero detail screen
    private let viewModel: HeroesDetailViewModel
    
    // MARK: - Initializer
    /// Initializes the view controller with a given ViewModel.
    /// - Parameter viewModel: The ViewModel handling the logic for this screen.
    init(viewModel: HeroesDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroesDetailViewController", bundle: Bundle(for: type(of: self)))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.load()
        transformationsButton.isHidden = true // Hide button initially
    }
    
    // MARK: - Setup Methods
    /// Binds the ViewModel state changes to UI updates.
    private func setupBindings() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case .error(let error):
                self?.renderError(error)
            }
        }
    }
    
    // MARK: - UI Update Methods
    /// Updates UI to reflect a loading state.
    private func renderLoading() {
        nameHero.text = "Loading..."
        descriptionLabel.text = nil
        heroImageView.image = nil
        transformationsButton.isHidden = true // Hide transformations button
    }
    
    /// Updates UI when hero details are successfully loaded.
    private func renderSuccess() {
        guard let hero = viewModel.hero else { return }
        
        nameHero.text = hero.name
        descriptionLabel.text = hero.description
        heroImageView.setImage(hero.photo)
        
        // Show or hide the transformations button based on whether there are transformations
        transformationsButton.isHidden = !viewModel.hasTransformations
    }
    
    /// Updates UI to reflect an error state.
    /// - Parameter error: The error message to display.
    private func renderError(_ error: String) {
        nameHero.text = "Failed to Load"
        descriptionLabel.text = error
        heroImageView.image = nil
        transformationsButton.isHidden = true // Hide button on error
    }
    
    // MARK: - Actions
    /// Called when the transformations button is tapped, navigating to the transformations list.
    /// - Parameter sender: The button triggering the action.
    @IBAction func onDidTapButtonTransformations(_ sender: Any) {
        guard let heroId = viewModel.hero?.id else {
            print("Hero ID is missing")
            return
        }
        
        // Navigate to the transformations list for the selected hero
        let transformationListViewController = TransformationListBuilder().build(heroId: heroId)
        navigationController?.pushViewController(transformationListViewController, animated: true)
    }
}
