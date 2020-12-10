import UIKit

protocol PaternNamingAlertDelegate: AnyObject {
    func paternNamingAlertOkPressedToCreatePatern(name: String)
    func patrnNamingAlertOkPressedToRenamePatern(name: String)
}

class PaternNamingAlert: UIView {

    //MARK: - @IBOutlets
    @IBOutlet var containerView: UIView!
    @IBOutlet var alertContainerView: UIView!
    @IBOutlet var paternNameTextField: UITextField!
    
    //MARK: - Properties
    weak var delegate: PaternNamingAlertDelegate?
    var paternName: String?
    var paternIndex: Int?
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    class func view() -> PaternNamingAlert? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? PaternNamingAlert
    }
    
    //MARK: - Interface
    func show(with name: String? = nil) {
        self.paternName = name
        guard let topViewController = UIApplication.topViewController() else { return }
        print("Here")
        self.translatesAutoresizingMaskIntoConstraints = false
//        guard let navigationController = topViewController.navigationController else {
//            return
//        }
        topViewController.view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topViewController.view.topAnchor),
            self.leftAnchor.constraint(equalTo: topViewController.view.leftAnchor),
            self.rightAnchor.constraint(equalTo: topViewController.view.rightAnchor),
            self.bottomAnchor.constraint(equalTo: topViewController.view.bottomAnchor, constant: 100)
        ])
        animateInAlert()
    }
    
    func hide() {
        animateOutAlert()
        paternIndex = nil
        paternName = nil
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        hide()
    }
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        guard let paternName = paternNameTextField.text, !paternName.isBlank() else { return }
        if let _ = self.paternName {
            delegate?.patrnNamingAlertOkPressedToRenamePatern(name: paternName)
            print(paternName)
        } else {
            delegate?.paternNamingAlertOkPressedToCreatePatern(name: paternName)
        }
     //   delegate?.paternNamingAlertOkPressedWith(name: paternName)
        hide()
    }
}

//MARK: - Private
private extension PaternNamingAlert {
    
    func setup() {
        self.containerView.alpha = 0
        self.alertContainerView.alpha = 0
    }
    
    func animateInAlert() {
        self.alertContainerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.alpha = 0.3
            self.alertContainerView.alpha = 1
            self.alertContainerView.transform = CGAffineTransform.identity
        })
    }
    
    func animateOutAlert() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.containerView.alpha = 0
                        self.alertContainerView.alpha = 0
                        self.alertContainerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        self.paternNameTextField.resignFirstResponder()
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
