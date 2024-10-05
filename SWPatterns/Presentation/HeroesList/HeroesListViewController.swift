import UIKit

/// ViewController responsible for displaying a list of heroes in a table view.
final class HeroesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Properties
    private let viewModel: HeroesListViewModel
    
    // MARK: - Initializer
    /// Initializes the `HeroesListViewController` with a view model.
    /// - Parameter viewModel: The `HeroesListViewModel` that handles the business logic for this view controller.
    init(viewModel: HeroesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroesListView", bundle: Bundle(for: type(of: self)))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title for the navigation bar and center it
        self.title = "Heroes"
        
        setupTableView()
        bind()  // Bind the view model's state changes
        viewModel.load()  // Trigger the loading of data
        
        // Handle the selection of a hero
        viewModel.onHeroSelected = { [weak self] hero in
            self?.navigateToHeroDetail(hero: hero)
        }
    }
    
    // MARK: - Setup
    /// Sets up the table view's data source, delegate, and registers the necessary cell.
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoRoundedAndLabelCell.nib, forCellReuseIdentifier: PhotoRoundedAndLabelCell.reuseIdentifier)
    }
    
    /// Binds the view model's state to update the view accordingly.
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
    
    // MARK: - Navigation
    /// Navigates to the hero detail view for the selected hero.
    /// - Parameter hero: The selected `Hero` to display details for.
    private func navigateToHeroDetail(hero: Hero) {
        let detailViewController = HeroesDetailBuilder().build(heroName: hero.name)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Actions
    /// Retry button action to reload the data when an error occurs.
    /// - Parameter sender: The button triggering the action.
    @IBAction func onRetryTapped(_ sender: Any) {
        errorLabel.text = "Error loading data. Please try again."
        viewModel.load()  // Retry loading the data
    }
    
    // MARK: - State Rendering
    /// Displays the loading state by showing the spinner and hiding the error container and table view.
    private func renderLoading() {
        spinner.startAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = true
    }
    
    /// Displays the success state by hiding the spinner, showing the table view, and reloading its data.
    private func renderSuccess() {
        spinner.stopAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    /// Displays the error state by showing the error message and hiding the table view and spinner.
    /// - Parameter reason: The error message to display.
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        errorContainer.isHidden = false
        tableView.isHidden = true
        errorLabel.text = reason
    }
    
    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.heroes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoRoundedAndLabelCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? PhotoRoundedAndLabelCell {
            let hero = viewModel.heroes[indexPath.row]
            cell.setAvatar(hero.photo)
            cell.setHeroName(hero.name)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectHero(at: indexPath.row)
    }
}
