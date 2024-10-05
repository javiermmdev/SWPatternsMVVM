import UIKit

/// ViewController responsible for displaying the details of a transformation.
final class TransformationDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var heroImageView: AsyncImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameHero: UILabel!
    
    // MARK: - Properties
    private let viewModel: TransformationDetailViewModel
    
    /// Initializes the ViewController with a ViewModel.
    ///
    /// - Parameter viewModel: The ViewModel that handles the logic for transformation details.
    init(viewModel: TransformationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TransformationDetailViewController", bundle: Bundle(for: type(of: self)))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.load()
    }
    
    // MARK: - Setup
    /// Binds the ViewModel's state changes to update the UI.
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
    
    // MARK: - Rendering Functions
    /// Renders the loading state.
    private func renderLoading() {
        nameHero.text = "Loading..."
        descriptionLabel.text = nil
        heroImageView.image = nil
    }
    
    /// Renders the success state with the transformation details.
    private func renderSuccess() {
        guard let transformation = viewModel.transformation else { return }
        
        nameHero.text = transformation.name
        descriptionLabel.text = transformation.description
        heroImageView.setImage(transformation.photo)
    }
    
    /// Renders the error state with an error message.
    ///
    /// - Parameter error: The error message to display.
    private func renderError(_ error: String) {
        nameHero.text = "Failed to load"
        descriptionLabel.text = error
        heroImageView.image = nil
    }
}
