import UIKit

protocol NutritionSettingView: AnyObject {
    func selectMode(at index: Int)
    func activateCustomEditingMode()
    func deactivateCustomEditingmode()
    func updateNutritionInfo(for calories: String, proteins: String, fats: String, carbohydrates: String)
    func updateCustomCaloriesLabel(to calories: String)
    func showNutrientsPickerWithPercentageFor(proteins: Int, carbohydrates: Int, fats: Int)
}

final class NutritionSettingViewController: BaseViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var customNutritionSettingView: UIView!
    @IBOutlet private var fatsPercentageLabel: UILabel!
    @IBOutlet private var carbohydratesPercentageLabel: UILabel!
    @IBOutlet private var proteinsPercentageLabel: UILabel!
    @IBOutlet private var caloriesLabel: UILabel!
    
    @IBOutlet private var nutritionsInfoLabels: [UILabel]!
    @IBOutlet private var caloriesTextFields: UITextField!
    
    // MARK: - GUI Properties
    private lazy var nutrientPercentagePicker = NutrientPercentagePickerView.view()
    
    // MARK: - Module propertie
    private let viewModel: NutritionSettingViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setup()
    }
    
    init(viewModel: NutritionSettingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        caloriesTextFields.keyboardType = .asciiCapableNumberPad
        addDoneButtonOnKeyboard()
        funetupNutrientPicker()
        saveButton.layer.cornerRadius = 20
        tableView.register(UINib(nibName: NutritionModeCell.xibName, bundle: nil),
                           forCellReuseIdentifier: NutritionModeCell.cellID)
    }
    
    private func updateLabelWithAnimation(_ label: UILabel, with text: String) {
        UIView.transition(with: label, duration: 0.4, options: .transitionCrossDissolve, animations: {
             label.text = text
        }, completion: nil)
    }
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(keyboardDoneButtonPressed))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        caloriesTextFields.inputAccessoryView = doneToolbar
    }
    
    private func funetupNutrientPicker() {
        nutrientPercentagePicker?.saveNutrientsWithpercentage = { [unowned self] (proteins, carbohydrates, fats) in
            viewModel.saveCustomNutrientsPercentageFor(proteins: proteins, carbohydrates: carbohydrates, fats: fats)
        }
    }
    
    // MARK: - Actions
    @objc private func keyboardDoneButtonPressed() {
        viewModel.saveCustomCalories(calories: caloriesTextFields.text)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        viewModel.saveButtonPressed()
    }
    
    @IBAction func fatLabelTapped(_ sender: Any) {
        viewModel.makronutrientsPercentageLabelTapped()
    }
    
    @IBAction func proteinLabelTapped(_ sender: Any) {
        viewModel.makronutrientsPercentageLabelTapped()
    }
    
    @IBAction func carbohydratesLabelTapped(_ sender: Any) {
        viewModel.makronutrientsPercentageLabelTapped()
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
        (cell as? NutritionModeCell)?.setCellName(viewModel.settingModel[indexPath.row].rawValue)
        viewModel.selectedIndex == indexPath.row ? (cell as? NutritionModeCell)?.showCheckMark() : (cell as? NutritionModeCell)?.hideCheckMark()
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NutritionSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - NutritionSettingView
extension NutritionSettingViewController: NutritionSettingView {
    
    func showNutrientsPickerWithPercentageFor(proteins: Int, carbohydrates: Int, fats: Int) {
        nutrientPercentagePicker?.showWith(proteinPercentage: proteins, carbohydratesPercentage: carbohydrates, fatsPercentage: fats)
    }
    
    func updateCustomCaloriesLabel(to calories: String) {
        caloriesTextFields.resignFirstResponder()
        caloriesLabel.isHidden = false
        caloriesTextFields.isHidden = true
        caloriesLabel.text = calories
    }
    
    func updateNutritionInfo(for calories: String, proteins: String, fats: String, carbohydrates: String) {
        updateLabelWithAnimation(caloriesLabel, with: calories)
        updateLabelWithAnimation(proteinsPercentageLabel, with: proteins)
        updateLabelWithAnimation(fatsPercentageLabel, with: fats)
        updateLabelWithAnimation(carbohydratesPercentageLabel, with: carbohydrates)
    }
    
    func activateCustomEditingMode() {
        caloriesLabel.isUserInteractionEnabled = true
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
                self.customNutritionSettingView.isUserInteractionEnabled = false
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
