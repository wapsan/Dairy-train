import UIKit

protocol SearchFoodView: AnyObject {
    func reloadFoodList()
}

final class SearchFoodViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Module properties
    private let viewModel: SearchFoodViewModelProtocol
    
    // MARK: - Lyfecycle
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
        tableView.register(UINib(nibName: NutritionSearchingCell.xibName, bundle: nil),
                           forCellReuseIdentifier: NutritionSearchingCell.cellID)
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

extension SearchFoodViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
}

// MARK: - SearchFoodView
extension SearchFoodViewController: SearchFoodView {
    
    func reloadFoodList() {
        hideLoader()
        tableView.reloadSections([0], with: .fade)
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
