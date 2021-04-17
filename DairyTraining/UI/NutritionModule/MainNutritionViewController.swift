import UIKit

protocol MainNutritionView: AnyObject {
    func updateMainInfoCell(for nutritionRecomendation: NutritionRecomendation)
    func updateMealPlaneLabelText(to text: String)
    func reloadTableView()
    func deleteCell(section: Int, row: Int)
    func updateMainCell()
}
 
final class MainNutritionViewController: DTBackgroundedViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView?
    
    // MARK: - Properties
    private let viewModel: NutritionViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setup()
    }
    
    // MARK: - Initialization
    init(viewModel: NutritionViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - Private methods
    private func setup() {
        navigationController?.navigationBar.isHidden = true
        tableView?.contentInset.bottom = 32
        tableView?.register(cell: NutritionMainCell.self)
        tableView?.register(cell: NutritionSearchingCell.self)
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
extension MainNutritionViewController: MainNutritionView {
    
    func updateMainCell() {
        tableView?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func deleteCell(section: Int, row: Int) {
        tableView?.beginUpdates()
        tableView?.deleteRows(at: [IndexPath(row: row, section: section)], with: .left)
        tableView?.endUpdates()
    }
    
    func reloadTableView() {
        tableView?.reloadData()
    }
    
    func updateMealPlaneLabelText(to text: String) {
        let cell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? NutritionMainCell
        cell?.setMealPlane(to: text)
    }
    
    
    func updateMainInfoCell(for nutritionRecomendation: NutritionRecomendation) {
        let cell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? NutritionMainCell
        cell?.setCell(for: nutritionRecomendation, and: viewModel.userNutritionData)
        tableView?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}

// MARK: - UITableViewDataSource
extension MainNutritionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectioncount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.rowInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NutritionMainCell.cellID, for: indexPath)
            (cell as? NutritionMainCell)?.setCell(for: viewModel.nutritionRecomendation, and: viewModel.userNutritionData)
            (cell as? NutritionMainCell)?.setMealPlane(to: viewModel.mealPlane)
            (cell as? NutritionMainCell)?.addMealButtonAction = { [unowned self] in
                self.viewModel.addMealButtonPressed()
            }
            (cell as? NutritionMainCell)?.settingButtonAction = { [unowned self] in
                self.viewModel.settinButtonPressed()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NutritionSearchingCell.cellID, for: indexPath)
            let meal = viewModel.meal(at: indexPath)
            cell.as(type: NutritionSearchingCell.self)?.setupCell(for: meal)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MainNutritionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section != 0 else { return nil }
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            tableView.performBatchUpdates({ [unowned self] in self.viewModel.didSwipeCell(at: indexPath) }, completion: nil)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else { return 0 }
        guard viewModel.shouldShowHeader(in: section) else { return 0 }
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }
        guard viewModel.shouldShowHeader(in: section) else { return nil }
        let header = TodayMealsTableSectionHeader.view()
        header?.title.text = viewModel.titleForSection(section)
        return header
    }
}
