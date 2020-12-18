import UIKit

protocol NutritionSettingView: AnyObject {
    func selectMode(at index: Int)
    func activateCustomEditingMode()
    func deactivateCustomEditingmode()
    func updateNutritionInfo(for calories: String, proteins: String, fats: String, carbohydrates: String)
}

final class NutritionSettingViewController: BaseViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var customNutritionSettingView: UIView!
    @IBOutlet private var fatsPercentageLabel: UILabel!
    @IBOutlet private var carbohydratesPercentageLabel: UILabel!
    @IBOutlet private var proteinsPercentageLabel: UILabel!
    @IBOutlet private var caloriesLabel: UILabel!
    @IBOutlet private var nutritionsInfoLabels: [UILabel]!
    @IBOutlet private var caloriesTextFields: UITextField!
    
    // MARK: - Module propertie
    private let viewModel: NutritionSettingViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        tableView.register(UINib(nibName: NutritionModeCell.xibName, bundle: nil),
                           forCellReuseIdentifier: NutritionModeCell.cellID)
    }
    
    init(viewModel: NutritionSettingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func updateLabelWithAnimation(_ label: UILabel, with text: String) {
        UIView.transition(with: label, duration: 0.4, options: .transitionCrossDissolve, animations: {
             label.text = text
        }, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any) {
        print("gdfgdf")
        viewModel.saveButtonPressed()
    }
    
    @IBAction func caloriesLabelTouched(_ sender: Any) {
        caloriesLabel.isHidden = true
        caloriesTextFields.isHidden = false
        caloriesTextFields.becomeFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension NutritionSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NutritionModeCell.cellID, for: indexPath)
        (cell as? NutritionModeCell)?.setCellName(viewModel.settingModel[indexPath.row].title)
        if viewModel.selectedIndex == indexPath.row {
            (cell as? NutritionModeCell)?.showCheckMark()
        } else {
            (cell as? NutritionModeCell)?.hideCheckMark()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NutritionSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - NutritionSettingView
extension NutritionSettingViewController: NutritionSettingView {
    
    
    func updateNutritionInfo(for calories: String, proteins: String, fats: String, carbohydrates: String) {
        updateLabelWithAnimation(caloriesLabel, with: calories)
        updateLabelWithAnimation(proteinsPercentageLabel, with: proteins)
        updateLabelWithAnimation(fatsPercentageLabel, with: fats)
        updateLabelWithAnimation(carbohydratesPercentageLabel, with: carbohydrates)
    }
    
    func activateCustomEditingMode() {
        tableView.isUserInteractionEnabled = false
        nutritionsInfoLabels.forEach({ label in
            UIView.transition(with: label, duration: 0.4, options: .transitionCrossDissolve, animations: {
                label.textColor = .white
            }, completion: { _ in
                self.customNutritionSettingView.isUserInteractionEnabled = true
                self.tableView.isUserInteractionEnabled = true
            })
        })
    }
    
    func deactivateCustomEditingmode() {
        caloriesTextFields.resignFirstResponder()
        caloriesTextFields.text = ""
        caloriesTextFields.isHidden = true
        caloriesLabel.isHidden = false
        tableView.isUserInteractionEnabled = false
        nutritionsInfoLabels.forEach({ label in
            UIView.transition(with: label, duration: 0.4, options: .transitionCrossDissolve, animations: {
                label.textColor = .lightGray
            }, completion: { _ in
                self.caloriesLabel.isUserInteractionEnabled = false
                self.tableView.isUserInteractionEnabled = true
            })
        })
    }
    
    func selectMode(at index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? NutritionModeCell
        cell?.showCheckMark()
        tableView.reloadData()
    }
}
