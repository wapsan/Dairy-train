import UIKit

protocol MealDetailAlertDelegate: AnyObject {
    func foodDetailAlert(mealDetailAlert: MealDetailAlert, mealWasAdded meal: MealResponseModel)
}

final class MealDetailAlert: UIView {
    
    // MARK: - @IBOutlets
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var foodNameLabel: UILabel!
    @IBOutlet private var cancelButton: UIButton!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var textField: UITextField!
    
    @IBOutlet private var caloriesLabel: UILabel!
    @IBOutlet private var carbohydratesLabel: UILabel!
    @IBOutlet private var fatsLabel: UILabel!
    @IBOutlet private var proteinsLabel: UILabel!
    
    private var foodWeight = 100
    private var food: Food?
    private var calories: Double = 0
    private var proteins: Double = 0
    private var carbohydrates: Double = 0
    private var fats: Double = 0
    
    weak var delegate: MealDetailAlertDelegate?
    
    // MARK: - Initialization
    static func view() -> MealDetailAlert? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? MealDetailAlert
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Publick methods
    func showWith(for foof: Food) {
        self.food = foof
        foodNameLabel.text = foof.lowercaseDescription?.capitalized
        textField.becomeFirstResponder()
        textField.keyboardType = .numberPad
        setupNutrientsLabelsFor(weight: foodWeight)
        guard let topViewController = UIApplication.topViewController() else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
//        guard let tabbarController = topViewController.tabBarController,
//              let tabbarviee = tabbarController.view else {
//            return
//        }
        topViewController.view.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topViewController.view.topAnchor),
            self.leftAnchor.constraint(equalTo: topViewController.view.leftAnchor),
            self.rightAnchor.constraint(equalTo: topViewController.view.rightAnchor),
            self.bottomAnchor.constraint(equalTo: topViewController.view.bottomAnchor)
        ])
        animatiInAlert()
    }
    
    // MARK: - Public methods
    private func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWilshShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func animatiInAlert() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0.5
        }, completion: nil)
    }
    
    private func hideAlert() {
        textField.text = String(foodWeight)
        animateoutAlert()
    }
    
    private func animateoutAlert() {
        textField.resignFirstResponder()
        UIView.animate(
            withDuration: 0.3, delay: 0, options: .curveEaseOut,
            animations: {
                self.backgroundView.alpha = 0.0
                self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height - 16)
            }, completion: { _ in
                self.removeFromSuperview()
            })
    }
    
    
    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let food = self.food else { return }
        let meal = MealResponseModel(mealName: food.foodName ?? "",
                             weight: Float(foodWeight),
                             calories: Float(calories),
                             proteins: Float(proteins),
                             carbohydrates: Float(carbohydrates),
                             fats: Float(fats))
        delegate?.foodDetailAlert(mealDetailAlert: self, mealWasAdded: meal)
        hideAlert()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let enteredText = sender.text,
              let enteredWeight = Int(enteredText)
              else { return }
        setupNutrientsLabelsFor(weight: enteredWeight)
    }
    
    func setupNutrientsLabelsFor(weight: Int) {
        guard let food = self.food else { return }
        foodWeight = weight
        let multiplier = Double(weight) / Double(100)
        caloriesLabel.text = String(format: "%.01f", food.calories * multiplier)
        proteinsLabel.text = String(format: "%.01f", food.proteins * multiplier)
        carbohydratesLabel.text = String(format: "%.01f", food.carbohydrates * multiplier)
        fatsLabel.text = String(format: "%.01f", food.fats * multiplier)
        calories = food.calories * multiplier
        proteins = food.proteins * multiplier
        carbohydrates = food.carbohydrates * multiplier
        fats = food.fats * multiplier
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        hideAlert()
    }
    
    @IBAction func backroundTapped(_ sender: Any) {
        hideAlert()
    }
    
    @objc private func keyBoardWilshShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.containerView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.containerView.transform = CGAffineTransform(translationX: 0, y: keyboardHeight)
    }
}
