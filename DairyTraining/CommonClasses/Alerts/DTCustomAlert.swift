import UIKit

protocol DTCustomAlertDelegate: AnyObject {
   // @objc optional func alertOkPressed(with newValue: String)
    func alertOkPressed(with infoViewType: InfoViewValueType)
 //   @objc optional func alertCancelPressed()
}

class DTCustomAlert: UIView {
    
    //MARK: - Singletone propertie
    static let shared = DTCustomAlert()
    
    //MARK: - Enum
    /**
    Type, wich set alert behavor for write data for user model.
     - **setValue** - type which set one of user parametrs like age, weight, gender etc.
     - **newAproachAlert** - type using for changing in training  approaches
     - **aproachAlert** -  type using for add new approaches
    */
    enum AlertType {
        case setValue
        case newAproachAlert
        case aproachAlert
    }
    
    //MARK: - Private properties
    /**
        Property based on tapped view type
    */
    private var alertType: DTCustomAlert.AlertType?
    private var changingAproachIndex: Int?
    private weak var mainInfo: MainInfoManagedObject?
    private weak var exercice: ExerciseManagedObject?
    private weak var tappedInfoView: DTMainInfoView?
    private lazy var setAgeTitle = LocalizedString.setAgeAlert
    private lazy var setWeightTitle = LocalizedString.setWeightAlert
    private lazy var setHeightTitle = LocalizedString.setHeightAlert
    
    //MARK: - Public properties
    weak var delegate: DTCustomAlertDelegate?
    
    //MARK: - Default GUI Properties
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = DTColors.backgroundColor//.viewFlipsideBckgoundColor
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 1
        view.layer.borderColor = DTColors.controllBorderColor.cgColor
       // view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerAlertView: UIView = {
         let view = UIView()
   
         view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tapForVisualEffectView: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.cancelPressed))
        return tap
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffectView = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffectView)
        visualEffectView.addGestureRecognizer(self.tapForVisualEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    private lazy var okButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: LocalizedString.ok)
        button.addTarget(self, action: #selector(self.okPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: LocalizedString.cancel)
        button.addTarget(self, action: #selector(self.cancelPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var systemButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.okButton)
        stackView.addArrangedSubview(self.cancelButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Weight/Height/Age type GUI properties
    private lazy var titleLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.textColor = .white
        label.textAlignment  = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var valueTextField: DTTextField = {
           let textField = DTTextField(placeholder: "")
           textField.font = .systemFont(ofSize: 40)
           textField.adjustsFontSizeToFitWidth = true
           textField.textAlignment = .center
           textField.textColor = .white
           textField.translatesAutoresizingMaskIntoConstraints = false
           return textField
    }()
    
    //MARK: - Gender type GUI properties
    private lazy var maleButton: DTAlertSelectionButton = {
        let button = DTAlertSelectionButton()
        button.infovalue = "Male"
        button.setTitle(NSLocalizedString("Male", comment: ""), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var femaleButton: DTAlertSelectionButton = {
        let button = DTAlertSelectionButton()
        button.infovalue = "Female"
        button.setTitle(NSLocalizedString("Female", comment: ""), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Activity type GUI properties
    private lazy var lowActivivtyButton: DTAlertSelectionButton = {
        let button = DTAlertSelectionButton()
        button.infovalue = "Low"
        button.setTitle(NSLocalizedString("Low", comment: ""), for: .normal)
        button.layer.borderColor = DTColors.controllBorderColor.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var midActivivtyButton: DTAlertSelectionButton = {
        let button = DTAlertSelectionButton()
        button.infovalue = "Mid"
        button.setTitle(NSLocalizedString("Mid", comment: ""), for: .normal)
        button.layer.borderColor = DTColors.controllBorderColor.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var highActivivtyButton: DTAlertSelectionButton = {
        let button = DTAlertSelectionButton()
        button.infovalue = "High"
        button.setTitle(NSLocalizedString("High", comment: ""), for: .normal)
        button.layer.borderColor = DTColors.controllBorderColor.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var selectionButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Aproach type GUI properties
    private lazy var repsTextField: DTTextField = {
        let textField = DTTextField(placeholder: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var repsLabel: UILabel = {
        let label = UILabel()
        label.text = " Reps."
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.backgroundColor = .clear
        label.textColor = .white
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weightTextField: DTTextField = {
        let textField = DTTextField(placeholder: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.text = MeteringSetting.shared.weightDescription
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weightBlockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(self.weightTextField)
        stackView.addArrangedSubview(self.weightLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var repsBlockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(self.repsTextField)
        stackView.addArrangedSubview(self.repsLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var infoBlockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(self.weightBlockStackView)
        stackView.addArrangedSubview(self.repsBlockStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Initialization
   private init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
   // self.delegate = DTMainInfoViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    /**
        Method which show custom alert with **setValue** type
           - Parameter viewController: UIViewControler which will be shown custom alert.
           - Parameter infoView: TDInfoView by clicking on which alert was called
     */
    func showInfoAlert(oVview: UIView, with infoView: DTMainInfoView) {
           oVview.addSubview(self)
           self.tappedInfoView = infoView
           guard let infoViewType = infoView._type else { return }
           switch infoViewType {
           case .gender:
               self.setUpGenderAlertType()
           case .activityLevel:
               self.setUpActivityLevelAlertType()
           case .age, .height, .weight:
               self.setUpValueAlertType(with: infoViewType)
               self.setUpKeyBoardStyle(for: self.valueTextField)
               self.showKeyboard(for: self.valueTextField)
           default:
               break
           }
           
          // self.delegate = viewController as? DTCustomAlertDelegate
           self.alertType = .setValue
           self.setUpDefaultsValue(with: infoView)
           self.animateInAlert()
       }
    
    func showInfoAlert(on viewController: UIViewController, with infoView: DTMainInfoView) {
        viewController.view.addSubview(self)
        self.tappedInfoView = infoView
        guard let infoViewType = infoView._type else { return }
        switch infoViewType {
        case .gender:
            self.setUpGenderAlertType()
        case .activityLevel:
            self.setUpActivityLevelAlertType()
        case .age, .height, .weight:
            self.setUpValueAlertType(with: infoViewType)
            self.setUpKeyBoardStyle(for: self.valueTextField)
            self.showKeyboard(for: self.valueTextField)
        default:
            break
        }
        
        self.delegate = viewController as? DTCustomAlertDelegate
        self.alertType = .setValue
        self.setUpDefaultsValue(with: infoView)
        self.animateInAlert()
    }
    
    /**
       Method which show custom alert with **aproachAlert** or **newAproachAlert** type
          - Parameter viewController: UIViewControler which will be shown custom alert.
          - Parameter exercice: Exercice in wich will add aproach data from alert.
          - Parameter aproachNumber: Aproach wich will be changed, if you add new aproach this parameter must be **nill**
    */
    func showAproachAlert(on viewController: UIViewController,
                          with exercice: ExerciseManagedObject,
                          and aproachNumber: Int?) {
        if let aproachIndex = aproachNumber {
            let aproach = exercice.aproachesArray[aproachIndex]
            self.titleLabel.text = "Aproach №\(aproachIndex + 1)"
            if aproach.weightMode == MeteringSetting.shared.weightMode.rawValue {
                if aproach.weight.truncatingRemainder(dividingBy: 1) == 0 {
                    self.weightTextField.text = String(format: "%.0f", aproach.weight)
                } else {
                    self.weightTextField.text = String(format: "%.1f", aproach.weight)
                }
            } else {
                let newWeight = aproach.weight * MeteringSetting.shared.weightMultiplier
                if newWeight.truncatingRemainder(dividingBy: 1) == 0 {
                    self.weightTextField.text = String(format: "%.0f", newWeight)
                } else {
                    self.weightTextField.text = String(format: "%.1f", newWeight)
                }
            }
            self.weightLabel.text = MeteringSetting.shared.weightDescription
            self.repsTextField.text = String(exercice.aproachesArray[aproachIndex].reps)
            self.changingAproachIndex = aproachIndex
            self.alertType = .aproachAlert
        } else {
            self.alertType = .newAproachAlert
            self.titleLabel.text = "Aproach №\(exercice.aproaches.count + 1)"
            self.setUpDefaultsAproach()
        }
        
        viewController.view.addSubview(self)
        self.delegate = viewController as? DTCustomAlertDelegate
        self.exercice = exercice
        self.setUpKeyBoardStyle(for: self.weightTextField)
        self.setUpKeyBoardStyle(for: self.repsTextField)
        self.showKeyboard(for: self.weightTextField)
        self.setUpAproachAlertType()
        self.animateInAlert()
    }

    //MARK: - Private methods
    private func setUpDefaultsValue(with infoView: DTMainInfoView) {
        if infoView.isValueSeted {
            guard let infoViewType = infoView._type else { return }
            switch infoViewType {
            case .gender, .activityLevel:
                for view in self.selectionButtonsStackView.arrangedSubviews {
                    guard let button = view as? UIButton else { return }
                    if button.currentTitle == infoView.valueLabel.text {
                        button.isSelected = true
                    } else {
                        button.isSelected = false
                    }
                    self.setButtonState(button)
                }
            case .age, .height, .weight:
                self.valueTextField.text = infoView.valueLabel.text
            default:
                break
            }
        } else {
            self.valueTextField.text = ""
        }
    }
    
    private func setUpDefaultsAproach() {
        self.repsTextField.text = ""
        self.weightTextField.text = ""
    }
    
    private func animateInAlert() {
        self.containerAlertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.containerAlertView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.alpha = 1
            self.containerAlertView.alpha = 1
            self.containerAlertView.transform = CGAffineTransform.identity
        })
    }
    
    private func animateOutAlert() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.containerAlertView.alpha = 0
                        self.containerAlertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { [weak self] (_) in
            guard let self = self else { return }
            guard let _ = self.superview else { return }
            self.cleanViews()
            self.deactivateAllConstraints()
            self.removeFromSuperview()
        }
    }
    
    private func hideAlert() {
        self.hideKeyboard()
        self.animateOutAlert()
    }
    
    private func setDefaultAlertType() {
        self.addSubview(self.visualEffectView)
        self.addSubview(self.containerAlertView)
        self.containerAlertView.addSubview(self.alertView)
        self.setUpDefaultsConstraints()
    }
    
    private func setUpValueAlertType(with valueToSet: InfoViewValueType) {
        self.setDefaultAlertType()
        self.alertView.addSubview(self.titleLabel)
        self.alertView.addSubview(self.valueTextField)
        self.alertView.addSubview(self.systemButtonsStackView)
        switch valueToSet {
        case .age:
            self.titleLabel.text = self.setAgeTitle
        case .height:
            self.titleLabel.text = self.setHeightTitle
        case .weight:
            self.titleLabel.text = self.setWeightTitle
        default:
            break
        }
        self.setUpValueAlertTypeConstraints()
    }
    
    private func setUpGenderAlertType() {
        self.setDefaultAlertType()
        self.selectionButtonsStackView.addArrangedSubview(self.maleButton)
        self.selectionButtonsStackView.addArrangedSubview(self.femaleButton)
        self.alertView.addSubview(self.selectionButtonsStackView)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.setUpListSelectionTypeConstraints()
    }
    
    private func setUpActivityLevelAlertType() {
        self.setDefaultAlertType()
        self.selectionButtonsStackView.addArrangedSubview(self.lowActivivtyButton)
        self.selectionButtonsStackView.addArrangedSubview(self.midActivivtyButton)
        self.selectionButtonsStackView.addArrangedSubview(self.highActivivtyButton)
        self.alertView.addSubview(self.selectionButtonsStackView)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.setUpListSelectionTypeConstraints()
    }
    
    private func setUpAproachAlertType() {
        self.setDefaultAlertType()
        self.alertView.addSubview(self.titleLabel)
        self.alertView.addSubview(self.infoBlockStackView)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.setUpAproachAlertTypeConstraints()
    }
    
    private func writeValueInfo() {
        guard let info = self.valueTextField.text,
            let infoFloat = Float(info),
            let tappedInfoViewValue = self.tappedInfoView?.type else { return }
        switch tappedInfoViewValue  {
        case .age:
            CoreDataManager.shared.updateAge(to: Int(infoFloat))
        case .weight:
            CoreDataManager.shared.updateWeight(to: infoFloat)
        case .height:
            CoreDataManager.shared.updateHeight(to: infoFloat)
        default:
            break
        }
    }
    
    private func writeListSelectionInfo() {
        for view in self.selectionButtonsStackView.arrangedSubviews {
            guard let button = view as? DTAlertSelectionButton else { return }
            if button.isSelected {
                guard let buttonValue = button.infovalue,
                    let tappedInfoViewType = self.tappedInfoView?.type else { return }
                switch tappedInfoViewType {
                case .gender:
                    guard let newGenderValue = UserMainInfoCodableModel.Gender.init(rawValue: buttonValue) else { return }
                    CoreDataManager.shared.updateGender(to: newGenderValue)
                case .activityLevel:
                    guard let newActivityLevelValue = UserMainInfoCodableModel.ActivityLevel.init(rawValue: buttonValue) else { return }
                    CoreDataManager.shared.updateActivityLevel(to: newActivityLevelValue)
                default:
                    break
                }
            }
        }
    }
    
    private func writeNewAproachInfo() {
        guard let reps = Int(self.repsTextField.text ?? "0") else { return }
        guard let weight = Float(self.weightTextField.text ?? "0") else { return }
        if let exercise = self.exercice {
           CoreDataManager.shared.addAproachWith(weight, and: reps, to: exercise)
        }
    }
    
    private func changeAproachInfo(for index: Int) {
        guard let reps = Int(self.repsTextField.text ?? "0") else { return }
        guard let weight = Float(self.weightTextField.text ?? "0") else { return }
        if let exercise = self.exercice {
            CoreDataManager.shared.changeAproachAt(index, in: exercise, with: weight, and: reps)
        }
    }
      
    private func setButtonState(_ button: UIButton) {
        button.layer.backgroundColor = button.isSelected ? DTColors.controllSelectedColor.cgColor : UIColor.clear.cgColor
    }
    
    private func setUpKeyBoardStyle(for textField: UITextField) {
        textField.keyboardType = .decimalPad
    }
    
    private func showKeyboard(for textField: UITextField) {
       textField.becomeFirstResponder()
    }
    
    private func hideKeyboard(for textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    private func deactivateAllConstraints() {
        NSLayoutConstraint.deactivate(self.constraints)
    }
    
    private func cleanViews() {
        self.alertView.subviews.forEach({ $0.removeFromSuperview() })
        self.selectionButtonsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    private func hideKeyboard() {
        self.valueTextField.resignFirstResponder()
        self.weightTextField.resignFirstResponder()
        self.repsTextField.resignFirstResponder()
    }
    
    private func resetTextFields() {
        self.valueTextField.text = nil
        self.weightTextField.text = nil
        self.repsTextField.text = nil
    }
    
    //MARK: - Constraints
    private func setUpDefaultsConstraints() {
        guard let superView = self.superview else { return }
        let safeArea = superView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.visualEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            self.visualEffectView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.visualEffectView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let widthContainerAlertViewConstraint = NSLayoutConstraint(item: self.containerAlertView,
                                                                   attribute: .width,
                                                                   relatedBy: .equal,
                                                                   toItem: self.containerAlertView,
                                                                   attribute: .height,
                                                                   multiplier: 1,
                                                                   constant: 0)
        widthContainerAlertViewConstraint.priority = UILayoutPriority(rawValue: 750)
        
        NSLayoutConstraint.activate([
            self.containerAlertView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor,
                                                         constant: DTEdgeInsets.small.top),
            self.containerAlertView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            self.containerAlertView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.containerAlertView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            widthContainerAlertViewConstraint
        ])
        
        NSLayoutConstraint.activate([
            self.alertView.topAnchor.constraint(equalTo: self.containerAlertView.topAnchor),
            self.alertView.leftAnchor.constraint(equalTo: self.containerAlertView.leftAnchor),
            self.alertView.rightAnchor.constraint(equalTo: self.containerAlertView.rightAnchor),
            self.alertView.bottomAnchor.constraint(equalTo: self.containerAlertView.bottomAnchor)
        ])
    }
    
    private func setUpValueAlertTypeConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.alertView.topAnchor,
                                                 constant: DTEdgeInsets.small.top),
            self.titleLabel.leftAnchor.constraint(equalTo: self.alertView.leftAnchor,
                                                  constant: DTEdgeInsets.small.left),
            self.titleLabel.rightAnchor.constraint(equalTo: self.alertView.rightAnchor,
                                                   constant: DTEdgeInsets.small.right),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.valueTextField.topAnchor,
                                                    constant: DTEdgeInsets.small.bottom)
        ])
        
        NSLayoutConstraint.activate([
            self.valueTextField.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor),
            self.valueTextField.centerYAnchor.constraint(equalTo: self.alertView.centerYAnchor),
            self.valueTextField.widthAnchor.constraint(equalTo: self.alertView.widthAnchor,
                                                       multiplier: 0.5),
            self.valueTextField.heightAnchor.constraint(equalTo: self.alertView.heightAnchor,
                                                        multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            self.systemButtonsStackView.topAnchor.constraint(greaterThanOrEqualTo: self.valueTextField.bottomAnchor,
                                                             constant: DTEdgeInsets.small.top),
            self.systemButtonsStackView.leftAnchor.constraint(equalTo: self.alertView.leftAnchor,
                                                              constant: DTEdgeInsets.medium.left),
            self.systemButtonsStackView.rightAnchor.constraint(equalTo: self.alertView.rightAnchor,
                                                               constant: DTEdgeInsets.medium.right),
            self.systemButtonsStackView.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor,
                                                                constant: DTEdgeInsets.small.bottom)
        ])
    }
    
    private func setUpListSelectionTypeConstraints() {
        let heightMultiplier: CGFloat =  CGFloat(self.selectionButtonsStackView.arrangedSubviews.count + 1)
        NSLayoutConstraint.activate([
            self.systemButtonsStackView.leftAnchor.constraint(equalTo: self.alertView.leftAnchor,
                                                              constant: DTEdgeInsets.medium.left),
            self.systemButtonsStackView.rightAnchor.constraint(equalTo: self.alertView.rightAnchor,
                                                               constant: DTEdgeInsets.medium.right),
            self.systemButtonsStackView.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor),
            self.systemButtonsStackView.heightAnchor.constraint(equalTo: self.alertView.heightAnchor,
                                                         multiplier: 1 / heightMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            self.selectionButtonsStackView.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: -1),
            self.selectionButtonsStackView.leftAnchor.constraint(equalTo: self.alertView.leftAnchor, constant: -1),
            self.selectionButtonsStackView.rightAnchor.constraint(equalTo: self.alertView.rightAnchor, constant: 1),
            self.selectionButtonsStackView.bottomAnchor.constraint(equalTo: self.systemButtonsStackView.topAnchor)
        ])
    }
    
    private func setUpAproachAlertTypeConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.alertView.topAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: self.alertView.leftAnchor,
                                                  constant: DTEdgeInsets.small.left),
            self.titleLabel.rightAnchor.constraint(equalTo: self.alertView.rightAnchor,
                                                   constant: DTEdgeInsets.small.right)
        ])
        
        NSLayoutConstraint.activate([
            self.infoBlockStackView.centerYAnchor.constraint(equalTo: self.alertView.centerYAnchor),
            self.infoBlockStackView.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor),
            self.infoBlockStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.infoBlockStackView.bottomAnchor.constraint(equalTo: self.systemButtonsStackView.topAnchor),
            self.infoBlockStackView.widthAnchor.constraint(equalTo: self.alertView.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            self.repsTextField.widthAnchor.constraint(equalTo: self.infoBlockStackView.widthAnchor,
                                                      multiplier: 1/3),
            self.weightTextField.widthAnchor.constraint(equalTo: self.infoBlockStackView.widthAnchor,
                                                        multiplier: 1/3)
        ])
        
        NSLayoutConstraint.activate([
            self.systemButtonsStackView.leftAnchor.constraint(equalTo: self.alertView.leftAnchor,
                                                              constant: DTEdgeInsets.small.left),
            self.systemButtonsStackView.rightAnchor.constraint(equalTo: self.alertView.rightAnchor,
                                                               constant: DTEdgeInsets.small.right),
            self.systemButtonsStackView.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor,
                                                                constant: DTEdgeInsets.small.bottom),
            self.systemButtonsStackView.heightAnchor.constraint(equalTo: self.alertView.heightAnchor,
                                                                multiplier: 0.25)
        ])
    }
    
    //MARK: - Actions
    @objc private func selectListButtonPressed(_ button: UIButton) {
        for view in self.selectionButtonsStackView.arrangedSubviews {
            guard let pickedButton = view as? UIButton else { return }
            pickedButton.isSelected = pickedButton != button ? false : true
            self.setButtonState(pickedButton)
        }
    }
    
    
    @objc private func okPressed() {
        self.writeValueInfo()
        
        NotificationCenter.default.post(name: .customAlerOkPressed, object: nil)
       // guard let tappedInfoViewType = self.tappedInfoView?.type else { return }
        guard let alertType = self.alertType else { return }
     //   self.delegate?.alertOkPressed(with: tappedInfoViewType)
        self.hideAlert()
        switch alertType {
        case .setValue:
            self.writeValueInfo()
            
        case .aproachAlert:
            break
        case .newAproachAlert:
            break
        }
//        switch alertType {
//        case .setValue:
//            guard let tappedInfoView = self.tappedInfoView else { return }
//            switch tappedInfoView.type {
//            case .gender:
//                self.writeListSelectionInfo()
//                if let localizedGender = CoreDataManager.shared.readUserMainInfo()?.displayGender {
//                  self.tappedInfoView?.valueLabel.text = NSLocalizedString(localizedGender, comment: "")
//                } else {
//                    self.tappedInfoView?.valueLabel.text = "_"
//                }
//            case .activityLevel:
//                self.writeListSelectionInfo()
//                if let localizedActivityLevel =  CoreDataManager.shared.readUserMainInfo()?.displayActivityLevel {
//                   self.tappedInfoView?.valueLabel.text = NSLocalizedString(localizedActivityLevel, comment: "")
//                } else {
//                    self.tappedInfoView?.valueLabel.text = "_"
//                }
//            case .age:
//                self.writeValueInfo()
//                self.tappedInfoView?.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayAge
//            case .height:
//                self.writeValueInfo()
//                 self.tappedInfoView?.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayHeight
//            case .weight:
//                self.writeValueInfo()
//                self.tappedInfoView?.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayWeight
//            default:
//                break
//            }
//        case .newAproachAlert:
//            self.writeNewAproachInfo()
//        case .aproachAlert:
//            guard let changinAproach = self.changingAproachIndex else { return }
//            self.changeAproachInfo(for: changinAproach)
//        }
//        self.hideAlert()
//        guard let alertOkPressed = self.delegate?.alertOkPressed?() else { return }
//        alertOkPressed
    }
    
    @objc private func cancelPressed() {
        self.hideAlert()
    //    guard let alertCancelTapped = self.delegate?.alertCancelPressed?() else { return }
        guard let tappedInfoView = self.tappedInfoView else { return }
        self.setUpDefaultsValue(with: tappedInfoView)
     //   alertCancelTapped
    }
}
