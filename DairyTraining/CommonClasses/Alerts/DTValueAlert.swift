import UIKit

protocol DTValueAletDelegate: AnyObject {
    func valueAlertOkPressed(valueAlert: DTValueAlert, with newValue: String?, and selectedIndex: Int)
    func valueAlertCancelPressed(valueAlert: DTValueAlert)
}

final class DTValueAlert: UIView {
    
    //MARK: - Properties
    weak var delegate: DTValueAletDelegate?
    
    //MARK: - Private properties
    private lazy var selectedCellIndex = 0
    private lazy var defaultValue = "-"
    
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
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tapForVisualEffectView: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.cancelPressed))
        return tap
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
//        viewController.view.addSubview(self)
//        self.setUpAlert()
        guard let cellType = MainInfoCellType.init(rawValue: index) else { return }
        switch cellType {
        case .age:
            self.titleLabel.text = LocalizedString.setAgeAlert
            viewController.view.addSubview(self)
            self.setUpAlert()
        case .hight:
            self.titleLabel.text = LocalizedString.setHeightAlert
            viewController.view.addSubview(self)
            self.setUpAlert()
        case .weight:
            self.titleLabel.text = LocalizedString.setWeightAlert
            viewController.view.addSubview(self)
            self.setUpAlert()
        default:
            break
        }
        self.valueTextField.text = value ?? self.defaultValue
        self.valueTextField.becomeFirstResponder()
        self.animateInAlert()
    }
    
//    func present(on viewController: UIViewController, for infoView: DTMainInfoView) {
//        guard let infoViewType = infoView._type else { return }
//        viewController.view.addSubview(self)
//        self.setUpAlert()
//        switch infoViewType {
//        case .age:
//            self.titleLabel.text = LocalizedString.setAgeAlert
//        case .height:
//            self.titleLabel.text = LocalizedString.setHeightAlert
//        case .weight:
//            self.titleLabel.text = LocalizedString.setWeightAlert
//        default:
//            break
//        }
//        
//        self.animateInAlert()
//    }
    
    private func animateInAlert() {
        self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alertView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        })
    }
    
    private func animateOutAlert() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertView.alpha = 0
                        self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { [weak self] _ in
            guard let self = self else { return }
           // guard let _ = self.superview else { return }
            self.cleanViews()
            self.deactivateAllConstraints()
            self.removeFromSuperview()
        }
    }
    
    private func deactivateAllConstraints() {
           NSLayoutConstraint.deactivate(self.constraints)
    }
       
    private func cleanViews() {
        self.alertView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func hideAlert() {
        self.animateOutAlert()
        self.valueTextField.resignFirstResponder()
    }
    
    
    private func setUpAlert() {
        self.addSubview(self.visualEffectView)
        self.addSubview(self.alertView)
        self.alertView.addSubview(self.titleLabel)
        self.alertView.addSubview(self.valueTextField)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.setUpDefaultsConstraints()
    }
    
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
    
    
    //MARK: - Actions
    @objc private func okPressed() {
        self.delegate?.valueAlertOkPressed(valueAlert: self,
                                           with: self.valueTextField.text,
                                           and: self.selectedCellIndex)
    }
    
    @objc private func cancelPressed() {
        self.delegate?.valueAlertCancelPressed(valueAlert: self)
       // self.hideAlert()
    }
    
    
}
