import UIKit

protocol SearchFoodView: AnyObject {
    func foodListWasUpdated()
    func errorWasUpdated(with massage: String)
}

final class SearchFoodViewController: UIViewController, Loadable {

    // MARK: - @IBOutlets
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorLabel: UILabel!
    
    // MARK: - GUI Properties
    private lazy var foodDetailAlert = MealDetailAlert.view()
    private lazy var refreshSpinner: UIActivityIndicatorView = {
        let indicatoor = UIActivityIndicatorView(style: .large)
        indicatoor.color = UIColor.white
        indicatoor.hidesWhenStopped = true
        return indicatoor
    }()
    
    // MARK: - Module properties
    private let viewModel: SearchFoodViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Initialization
    init(viewModel: SearchFoodViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        searchBar.searchTextField.textColor = .white
        tableView.tableFooterView = refreshSpinner
        tableView.register(UINib(nibName: NutritionSearchingCell.xibName, bundle: nil),
                           forCellReuseIdentifier: NutritionSearchingCell.cellID)
        foodDetailAlert?.delegate = viewModel
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        viewModel.cancelButtonPressed()
    }
}

// MARK: - UIScrollViewDelegate
extension SearchFoodViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) else { return }
        refreshSpinner.startAnimating()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height
        guard endScrolling >= scrollView.contentSize.height else { return }
        viewModel.activatePaginationRequest()
    }
}


// MARK: - UITableViewDataSource
extension SearchFoodViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NutritionSearchingCell.cellID, for: indexPath)
        (cell as? NutritionSearchingCell)?.setupCell(for: viewModel.foodList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchFoodViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foodDetailAlert?.showWith(for: viewModel.foodList[indexPath.row])
    }
}

// MARK: - SearchFoodView
extension SearchFoodViewController: SearchFoodView {
    
    func errorWasUpdated(with massage: String) {
        hideLoader()
        errorLabel.isHidden = false
        tableView.isHidden = true
        errorLabel.text = massage
    }
    
    func foodListWasUpdated() {
        hideLoader()
        refreshSpinner.stopAnimating()
        errorLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension SearchFoodViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchingText = searchBar.text, !searchingText.isBlank() else { return }
        showLoader()
        viewModel.requestFood(for: searchingText)
        searchBar.resignFirstResponder()
    }
}
