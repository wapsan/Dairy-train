import UIKit

protocol DTSelectionListAlertDelegate: AnyObject {
    func selectionListAlertOkPressed(selectionListAlert: DTSelectionListAlert,
                                     with newValue: String?,
                                     for selectedIndex: Int )
    func selectionListAlertCancelPressed(selectionListAlert: DTSelectionListAlert)
}

class DTSelectionListAlert: UIView {
    
    //MARK: - Properties
    weak var delegate: DTSelectionListAlertDelegate?
    private lazy var selectedCellIndex = 0
    
    //MARK: - GUI Properties
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffectView = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffectView)
        visualEffectView.addGestureRecognizer(self.tapForVisualEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = DTColors.backgroundColor
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 1
        view.layer.borderColor = DTColors.controllBorderColor.cgColor
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var tapForVisualEffectView: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.cancelPressed))
        return tap
    }()

    private lazy var maleButton: DTAlertSelectionButton = {
        let button = DTAlertSelectionButton()
        button.infovalue = "Male"
        button.setTitle(NSLocalizedString("Male", comment: ""), for: .normal)
        button.layer.borderColor = DTColors.controllBorderColor.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var femaleButton: DTAlertSelectionButton = {
        let button = DTAlertSelectionButton()
        button.infovalue = "Female"
        button.setTitle(NSLocalizedString("Female", comment: ""), for: .normal)
        button.layer.borderColor = DTColors.controllBorderColor.cgColor
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
    
    //MARK: - Initialization
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func present(on viewController: UIViewController, for index: Int, and value: String?) {
        self.selectedCellIndex = index
        guard let cellType = ProfileInfoCellType.init(rawValue: index) else { return }
        switch cellType {
        case .gender:
            viewController.view.addSubview(self)
            self.setUpGenderSelectionList()
        case .activityLevel:
            viewController.view.addSubview(self)
            self.setUpActivityLevelSelectionList()
        default:
            break
        }
        self.setSelectedValue(to: value)
        self.animateInAlert()
    }
    
    func hideAlert() {
        self.animateOutAlert()
    }
}

//MARK: - Private extension
private extension DTSelectionListAlert {
    
    func animateInAlert() {
        self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alertView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        })
    }
    
    func animateOutAlert() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertView.alpha = 0
                        self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { [weak self] _ in
            guard let self = self else { return }
            self.cleanViews()
            self.deactivateAllConstraints()
            self.removeFromSuperview()
        }
    }
    
    func deactivateAllConstraints() {
        NSLayoutConstraint.deactivate(self.constraints)
    }
    
    func cleanViews() {
        self.alertView.subviews.forEach({ $0.removeFromSuperview() })
        self.selectionButtonsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func setButtonState(_ button: UIButton) {
        button.layer.backgroundColor = button.isSelected ? DTColors.controllSelectedColor.cgColor : UIColor.clear.cgColor
    }
    
    func setSelectedValue(to value: String?) {
        guard let value = value else { return }
        for button in self.selectionButtonsStackView.arrangedSubviews {
            if let selectionButton = button as? DTAlertSelectionButton,
                let infoValue = selectionButton.titleLabel?.text {
                selectionButton.isSelected = infoValue == value ? true : false
                self.setButtonState(selectionButton)
            }
        }
    }
    
    func setUpGenderSelectionList() {
        self.addSubview(self.visualEffectView)
        self.addSubview(self.alertView)
        self.alertView.addSubview(self.selectionButtonsStackView)
        self.selectionButtonsStackView.addArrangedSubview(self.maleButton)
        self.selectionButtonsStackView.addArrangedSubview(self.femaleButton)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.setUpDefaultsConstraints()
    }
    
    func setUpActivityLevelSelectionList() {
        self.addSubview(self.visualEffectView)
        self.addSubview(self.alertView)
        self.alertView.addSubview(self.selectionButtonsStackView)
        self.selectionButtonsStackView.addArrangedSubview(self.lowActivivtyButton)
        self.selectionButtonsStackView.addArrangedSubview(self.midActivivtyButton)
        self.selectionButtonsStackView.addArrangedSubview(self.highActivivtyButton)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.setUpDefaultsConstraints()
    }
    
    func setUpDefaultsConstraints() {
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
        
        let widthContainerAlertViewConstraint = NSLayoutConstraint(item: self.alertView,
                                                                   attribute: .width,
                                                                   relatedBy: .equal,
                                                                   toItem: self.alertView,
                                                                   attribute: .height,
                                                                   multiplier: 1,
                                                                   constant: 0)
        widthContainerAlertViewConstraint.priority = UILayoutPriority(rawValue: 750)
        
        NSLayoutConstraint.activate([
            self.alertView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor,
                                                constant: DTEdgeInsets.small.top),
            self.alertView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            self.alertView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.alertView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            widthContainerAlertViewConstraint
        ])
        
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
    
    //MARK: - Actions
    @objc func okPressed() {
        var newValue: String?
        for view in self.selectionButtonsStackView.arrangedSubviews {
            guard let button = view as? DTAlertSelectionButton else { return }
            if button.isSelected {
                newValue = button.infovalue
            }
        }
        self.delegate?.selectionListAlertOkPressed(selectionListAlert: self,
                                                   with: newValue,
                                                   for: self.selectedCellIndex)
    }
    
    @objc func cancelPressed() {
        self.delegate?.selectionListAlertCancelPressed(selectionListAlert: self)
    }
    
    @objc func selectListButtonPressed(_ button: UIButton) {
        for view in self.selectionButtonsStackView.arrangedSubviews {
            guard let pickedButton = view as? UIButton else { return }
            pickedButton.isSelected = pickedButton != button ? false : true
            self.setButtonState(pickedButton)
        }
    }
}
