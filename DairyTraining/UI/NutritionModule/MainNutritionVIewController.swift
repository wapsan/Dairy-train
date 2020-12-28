import UIKit

protocol MainNutritionView: AnyObject {
    func updateMainInfoCell(for nutritionRecomendation: NutritionRecomendation)
    func updateMealPlaneLabelText(to text: String)
    func reloadTableView()
    func deleteCell(section: Int, row: Int)
    func updateMainCell()
}
 
final class MainNutritionVIewController: DTBackgroundedViewController {

    // MARK: - @IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel: NutritionViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
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
        tableView.contentInset.bottom = 32
        tableView.register(UINib(nibName: NutritionMainCell.xibName, bundle: nil),
                           forCellReuseIdentifier: NutritionMainCell.cellID)
        tableView.register(UINib(nibName: NutritionSearchingCell.xibName, bundle: nil),
                           forCellReuseIdentifier: NutritionSearchingCell.cellID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Setting",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(settinButtonPressed))
    }

    // MARK: - Actions
    @objc private func settinButtonPressed() {
        viewModel.settinButtonPressed()
    }
}

// MARK: - MainNutritionView
extension MainNutritionVIewController: MainNutritionView {
    
    func updateMainCell() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func deleteCell(section: Int, row: Int) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .left)
        tableView.endUpdates()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func updateMealPlaneLabelText(to text: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NutritionMainCell
        cell?.setMealPlane(to: text)
    }
    
    
    func updateMainInfoCell(for nutritionRecomendation: NutritionRecomendation) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NutritionMainCell
        cell?.setCell(for: nutritionRecomendation, and: viewModel.userNutritionData)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}

// MARK: - UITableViewDataSource
extension MainNutritionVIewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.todayMealNutitionModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.todayMealNutitionModel[section].meals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NutritionMainCell.cellID, for: indexPath)
            (cell as? NutritionMainCell)?.setCell(for: viewModel.nutritionRecomendation, and: viewModel.userNutritionData)
            (cell as? NutritionMainCell)?.setMealPlane(to: viewModel.mealPlane)
            (cell as? NutritionMainCell)?.addMealButtonAction = { [unowned self] in
                self.viewModel.addMealButtonPressed()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NutritionSearchingCell.cellID, for: indexPath)
            let meal = viewModel.todayMealNutitionModel[indexPath.section].meals[indexPath.row]
            (cell as? NutritionSearchingCell)?.setupCell(for: meal)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MainNutritionVIewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section != 0 else { return nil }
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            tableView.performBatchUpdates({ [weak self] in
                self?.viewModel.cellWasSwiped(at: indexPath.section, and: indexPath.row)
            }, completion: nil)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else { return 0 }
        guard !viewModel.todayMealNutitionModel[section].meals.isEmpty else { return 0 }
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }
        guard !viewModel.todayMealNutitionModel[section].meals.isEmpty else { return nil }
        let header = TodayMealsTableSectionHeader.view()
        header?.title.text = viewModel.todayMealNutitionModel[section].rawValue
        return header
    }
}
