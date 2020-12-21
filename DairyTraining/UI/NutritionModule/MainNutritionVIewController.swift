import UIKit

protocol MainNutritionView: AnyObject {
    func updateMainInfoCell(for nutritionRecomendation: NutritionRecomendation)
    func updateMealPlaneLabelText(to text: String)
    func updateMeals()
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
        tableView.register(UINib(nibName: NutritionMainCell.xibName, bundle: nil), forCellReuseIdentifier: NutritionMainCell.cellID)
        tableView.register(UINib(nibName: NutritionSearchingCell.xibName, bundle: nil), forCellReuseIdentifier: NutritionSearchingCell.cellID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonPressed))
    }

    // MARK: - Actions
    @objc private func addButtonPressed() {
        MainCoordinator.shared.coordinateChild(to: NutritionModuleCoordinator.Target.searchFood)
    }
}

// MARK: - MainNutritionView
extension MainNutritionVIewController: MainNutritionView {
    
    func updateMeals() {
        tableView.reloadData()
    }
    
    func updateMealPlaneLabelText(to text: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NutritionMainCell
        cell?.setMealPlane(to: text)
    }
    
    
    func updateMainInfoCell(for nutritionRecomendation: NutritionRecomendation) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NutritionMainCell
        cell?.setCell(for: nutritionRecomendation, and: viewModel.USERnutritionData)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}

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
            (cell as? NutritionMainCell)?.setCell(for: viewModel.nutritionRecomendation, and: viewModel.USERnutritionData)
            (cell as? NutritionMainCell)?.setMealPlane(to: viewModel.mealPlane)
            (cell as? NutritionMainCell)?.settingButtonPressedAction = { [unowned self] in
                MainCoordinator.shared.coordinateChild(to: NutritionModuleCoordinator.Target.nutritionSetting)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NutritionSearchingCell.cellID, for: indexPath)
            (cell as? NutritionSearchingCell)?.setupCell(for: viewModel.todayMealNutitionModel[indexPath.section].meals[indexPath.row])
            return cell
        }
     
    }
}

extension MainNutritionVIewController: UITableViewDelegate {
    
    
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
