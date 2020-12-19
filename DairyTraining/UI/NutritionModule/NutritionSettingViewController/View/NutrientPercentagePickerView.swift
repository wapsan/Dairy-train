import UIKit

final class NutrientPercentagePickerView: UIView {
    
    // MARK: - @IBOutlets
    @IBOutlet private var caloriesPercenatgePicker: UIPickerView!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var percentageSumLabel: UILabel!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private  var backgroundView: UIView!
    
    @IBOutlet var cancelButton: UIButton!
    // MARK: - Properties
    private var summ: Int = 0 {
        didSet {
            updateSaveButtonState()
            updateSumPercentageLabel()
        }
    }
    
    private var carbohydrates = 0
    private var proteins = 0
    private var fats = 0
    var saveNutrientsWithpercentage: ((_ protein: Int, _ carbohydrates: Int, _ fats: Int) -> Void)?
    
    // MARK: - Initialization
    static func view() -> NutrientPercentagePickerView? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? NutrientPercentagePickerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Publick methods
    func showWith(proteinPercentage: Int, carbohydratesPercentage: Int, fatsPercentage: Int) {
        NutrientsComponents.allCases.forEach({ component in
            switch component {
            case .proteins:
                proteins = proteinPercentage
                guard let a = CaloriesPercentagepickerModel(rawValue: proteinPercentage) else { return }
                guard let index = CaloriesPercentagepickerModel.allCases.firstIndex(of: a) else { return }
                caloriesPercenatgePicker.selectRow(index, inComponent: 0, animated: false)
                pickerView(caloriesPercenatgePicker, didSelectRow: index, inComponent: 0)
            case .carbohydrates:
                carbohydrates = carbohydratesPercentage
                guard let a = CaloriesPercentagepickerModel(rawValue: carbohydratesPercentage) else { return }
                guard let index = CaloriesPercentagepickerModel.allCases.firstIndex(of: a) else { return }
                caloriesPercenatgePicker.selectRow(index, inComponent: 1, animated: false)
                pickerView(caloriesPercenatgePicker, didSelectRow: index, inComponent: 1)
            case .fats:
                fats = fatsPercentage
                guard let a = CaloriesPercentagepickerModel(rawValue: fatsPercentage) else { return }
                guard let index = CaloriesPercentagepickerModel.allCases.firstIndex(of: a) else { return }
                caloriesPercenatgePicker.selectRow(index, inComponent: 2, animated: false)
                pickerView(caloriesPercenatgePicker, didSelectRow: index, inComponent: 2)
            }
        })
       
        guard let topViewController = UIApplication.topViewController() else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let tabbarController = topViewController.tabBarController,
              let tabbarviee = tabbarController.view else {
            return
        }
        tabbarviee.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: tabbarviee.topAnchor),
            self.leftAnchor.constraint(equalTo: tabbarviee.leftAnchor),
            self.rightAnchor.constraint(equalTo: tabbarviee.rightAnchor),
            self.bottomAnchor.constraint(equalTo: tabbarviee.bottomAnchor)
        ])
        animatiInAlert()
    }
    
    // MARK: - Private methods
    private func setup() {
        caloriesPercenatgePicker.delegate = self
        caloriesPercenatgePicker.dataSource = self
        containerView.backgroundColor = .systemBlue
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 20
        caloriesPercenatgePicker.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = summ == 100
    }
    
    private func updateSumPercentageLabel() {
        switch summ {
        case let sum where sum > 100:
            percentageSumLabel.textColor = .red
        case let sum where sum < 100:
            percentageSumLabel.textColor = .black
        case 100:
            percentageSumLabel.textColor = .green
        default:
            break
        }
        percentageSumLabel.text = String(summ) + " %"
    }
    
    private func animatiInAlert() {
        containerView.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0.5
            self.containerView.transform = .identity
        }, completion: nil)
    }
    
    private func hideAlert() {
        animateoutAlert()
    }
    
    private func animateoutAlert() {
        UIView.animate(
            withDuration: 0.3, delay: 0, options: .curveEaseOut,
            animations: {
                self.backgroundView.alpha = 0.0
                self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height)
            }, completion: { _ in
                self.removeFromSuperview()
            })
    }
    
    // MARK: - Actions
    @IBAction func backgroundViewTapped(_ sender: Any) {
        hideAlert()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        hideAlert()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveNutrientsWithpercentage?(proteins,carbohydrates,fats)
        hideAlert()
    }
}

// MARK: - UIPickerViewDelegate
extension NutrientPercentagePickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch NutrientsComponents.allCases[component] {
        case .proteins:
            proteins = 0
            proteins =  CaloriesPercentagepickerModel.allCases[row].rawValue
        case .carbohydrates:
            carbohydrates = 0
            carbohydrates = CaloriesPercentagepickerModel.allCases[row].rawValue
        case .fats:
            fats = 0
            fats = CaloriesPercentagepickerModel.allCases[row].rawValue
        }
        summ = fats + carbohydrates + proteins
    }
}

// MARK: - UIPickerViewDataSource
extension NutrientPercentagePickerView: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = CaloriesPercentagepickerModel.allCases[row].title
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return NutrientsComponents.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CaloriesPercentagepickerModel.allCases.count
    }
}

// MARK: - Models
fileprivate enum NutrientsComponents: String, CaseIterable {
    case proteins
    case carbohydrates
    case fats

}

fileprivate enum CaloriesPercentagepickerModel: Int, CaseIterable {
    case zero = 0
    case five = 5
    case ten = 10
    case fifteen = 15
    case twenty = 20
    case twentyfive = 25
    case thirty = 30
    case thirtyfive = 35
    case forty = 40
    case fortyfive = 45
    case fifty = 50
    case fiftyfive = 55
    case sixty = 60
    case sixtyfive = 65
    case seventy = 70
    case seventyfive = 75
    case eighty = 80
    case eightyfive = 85
    case ninety = 90
    case ninetyfive = 95
    case hundred = 100
    
    var title: String {
        return String(self.rawValue) + "%"
    }
}
