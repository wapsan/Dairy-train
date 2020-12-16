import UIKit

protocol MainNutritionView: AnyObject {
    
}
 
final class MainNutritionVIewController: DTBackgroundedViewController {

    // MARK: - @IBOutlets
    @IBOutlet var tableView: UITableView!
    
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
  
}

extension MainNutritionVIewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.todayMealNutitionModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else {
            return viewModel.todayMealNutitionModel[section].meals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NutritionMainCell.cellID, for: indexPath)
        (cell as? NutritionMainCell)?.setCell(for: viewModel.nutritionRecomendation, and: viewModel.USERnutritionData)
        (cell as? NutritionMainCell)?.settingButtonPressedAction = { [unowned self] in
            MainCoordinator.shared.coordinateChild(to: NutritionModuleCoordinator.Target.nutritionSetting)
        }
        return cell
    }
}
