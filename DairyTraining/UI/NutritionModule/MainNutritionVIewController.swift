import UIKit

protocol MainNutritionView: AnyObject {
    func updateFoodList()
}
 
final class MainNutritionVIewController: DTBackgroundedViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var searcViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchButton: UIButton!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var searchContainerView: UIView!
    
    // MARK: - Properties
    private let viewModel: NutritionViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Initialization
    init(viewModel: NutritionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .white
        tableView.register(UINib(nibName: NutritionSearchingCell.xibName, bundle: nil),
                           forCellReuseIdentifier: NutritionSearchingCell.cellID)
        tableView.rowHeight = 120
    }
    
    // MARK: - Actions
    @IBAction func searchButtonPressed(_ sender: Any) {
        guard let searchingText = searchBar.text else { return }
        viewModel.requestFood(for: searchingText)
    }
    
}

// MARK: - UITableViewDataSource
extension MainNutritionVIewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NutritionSearchingCell.cellID, for: indexPath)
        (cell as? NutritionSearchingCell)?.setupCell(for: viewModel.foodList[indexPath.row])
        return cell
    }
}

// MARK: - MainNutritionView
extension MainNutritionVIewController: MainNutritionView {
    
    func updateFoodList() {
        tableView.reloadSections([0], with: .fade)
    }
}
