import UIKit

protocol MainNutritionView: AnyObject {
    func updateMainInfoCell(for nutritionRecomendation: NutritionRecomendation)
    func updateMealPlaneLabelText(to text: String)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NutritionMainCell.cellID, for: indexPath)
        (cell as? NutritionMainCell)?.setCell(for: viewModel.nutritionRecomendation, and: viewModel.USERnutritionData)
        (cell as? NutritionMainCell)?.setMealPlane(to: viewModel.mealPlane)
        (cell as? NutritionMainCell)?.settingButtonPressedAction = { [unowned self] in
            MainCoordinator.shared.coordinateChild(to: NutritionModuleCoordinator.Target.nutritionSetting)
        }
        return cell
    }
}
