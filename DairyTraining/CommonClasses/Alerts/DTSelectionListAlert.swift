import UIKit

protocol DTSelectionListAlertDelegate: AnyObject {
    func selectionListAlertOkPressed(selectionListAlert: DTSelectionListAlertDelegate,
                                     with newValue: String,
                                     for selectedIndex: Int )
    func selectionListAlertOkPressed(selectionListAlert: DTSelectionListAlertDelegate)
}

class DTSelectionListAlert: UIView {
    
    //MARK: - Properties
    weak var delegate: DTSelectionListAlertDelegate?
    
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
              self.cleanViews()
              self.deactivateAllConstraints()
              self.removeFromSuperview()
          }
      }
    
    //FIXME: fINISH LIST SELECTIOn ALERTFI
    
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
    
      
    init() {
           super.init(frame: .zero)
           self.translatesAutoresizingMaskIntoConstraints = false
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    private lazy var selectedCellIndex = 0
    
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
        
            self.animateInAlert()
        }
    
      private func deactivateAllConstraints() {
             NSLayoutConstraint.deactivate(self.constraints)
      }
         
      private func cleanViews() {
          self.alertView.subviews.forEach({ $0.removeFromSuperview() })
      }
      
      func hideAlert() {
          self.animateOutAlert()
      }
    
    
    @objc private func okPressed() {

    }
    
    @objc private func cancelPressed() {

    }
    
    @objc private func selectListButtonPressed(_ button: UIButton) {
           for view in self.selectionButtonsStackView.arrangedSubviews {
               guard let pickedButton = view as? UIButton else { return }
               pickedButton.isSelected = pickedButton != button ? false : true
               self.setButtonState(pickedButton)
           }
       }
    
    private func setButtonState(_ button: UIButton) {
        button.layer.backgroundColor = button.isSelected ? DTColors.controllSelectedColor.cgColor : UIColor.clear.cgColor
    }
    
}
