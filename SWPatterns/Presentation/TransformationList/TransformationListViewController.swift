import UIKit

/// ViewController responsible for displaying a list of transformations.
final class TransformationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Properties
    private let viewModel: TransformationListViewModel

    // MARK: - Initializer
    /// Initializes the view controller with a given ViewModel.
    /// - Parameter viewModel: The ViewModel used to manage the transformation list logic.
    init(viewModel: TransformationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TransformationListViewController", bundle: Bundle(for: type(of: self)))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
        viewModel.load()
        
        // Set the title for the navigation bar and center it
        self.title = "Transformations"
        
        // Setup callback for transformation selection
        viewModel.onTransformationSelected = { [weak self] heroId, transformationId in
            self?.navigateToTransformationDetail(heroId: heroId, transformationId: transformationId)
        }
    }

    // MARK: - Setup Methods
    /// Sets up the table view data source and registers the necessary cell.
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoRoundedAndLabelCell.nib, forCellReuseIdentifier: PhotoRoundedAndLabelCell.reuseIdentifier)
    }
    
    /// Binds the ViewModel's state changes to the UI.
    private func bind() {
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

    // MARK: - UI Rendering
    /// Displays the error message and hides the table view and spinner.
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        errorContainer.isHidden = false
        tableView.isHidden = true
        errorLabel.text = reason
    }
    
    /// Shows the loading spinner while hiding the table view and error container.
    private func renderLoading() {
        spinner.startAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = true
    }
    
    /// Updates the UI when data is successfully loaded, or shows an error if no data is found.
    private func renderSuccess() {
        guard !viewModel.transformations.isEmpty else {
            renderError("No transformations found.")
            return
        }

        spinner.stopAnimating()
        spinner.isHidden = true
        errorContainer.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transformations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoRoundedAndLabelCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? PhotoRoundedAndLabelCell {
            let transformation = viewModel.transformations[indexPath.row]
            cell.setAvatar(transformation.photo)
            cell.setHeroName(transformation.name)
        }
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectTransformation(at: indexPath.row)
    }

    // MARK: - Navigation
    /// Navigates to the `TransformationDetailViewController` for the selected transformation.
    /// - Parameters:
    ///   - heroId: The ID of the hero.
    ///   - transformationId: The ID of the transformation.
    private func navigateToTransformationDetail(heroId: String, transformationId: String) {
        let detailViewController = TransformationDetailBuilder().build(heroId: heroId, transformationId: transformationId)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
