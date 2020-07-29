import UIKit

protocol LoginViewControllerPresenter: AnyObject {
    func signInSuccesed()
    func signInFailed(with errorMessage: String) 
    
    func startSigninIn()
    
    func failedSignUp(with errorMessage: String)
    func succesSignUp()
    
    func googleSignInStart()
}

final class LoginViewController: UIViewController {
    
    //MARK: - Private properties
    private lazy var isSignInMode: Bool = true
    var viewModel: LoginViewModel!
    
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - GUI Properties
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.mainLogo)
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.textLogo
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var modeSegmentedControll: UISegmentedControl = {
        let segmentedControll = UISegmentedControl()
        segmentedControll.insertSegment(withTitle: LocalizedString.signIn,
                                        at: 0,
                                        animated: true)
        segmentedControll.insertSegment(withTitle: LocalizedString.signUp,
                                        at: 1,
                                        animated: true)
        segmentedControll.backgroundColor = .viewFlipsideBckgoundColor
        segmentedControll.selectedSegmentTintColor = .red
        segmentedControll.selectedSegmentIndex = 0
        segmentedControll.addTarget(self, action: #selector(self.modeSwitched(_:)), for: .valueChanged)
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        segmentedControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white],
                                                 for: .normal)
        return segmentedControll
    }()
    
    private lazy var emailTextField: DTTextField = {
        let textField = DTTextField(placeholder: LocalizedString.email)
        textField.tag = 0
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: DTTextField = {
        let textField = DTTextField(placeholder: LocalizedString.password)
        textField.tag = 1
        textField.delegate = self
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var mainSignButton: DTSystemButton = {
        let button = DTSystemButton(tittle: LocalizedString.signIn)
        button.addTarget(self,
                         action: #selector(self.mainSignInButtonPressed(_:)),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var googleSignInButton: GoogleSignInButton = {
        let button = GoogleSignInButton()
        button.addTarget(self,
                         action: #selector(self.googleSignInPressed),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.or
        label.font = .boldSystemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let activityIndicator: DTActivityIndicator = {
        let indicator = DTActivityIndicator()
        return indicator
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.setUpGooglePresentingViewController(to: self)
        self.setGuiElements()
        self.addObserverForKeyboardShow()
        self.addObserverForHideKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
      //  self.downloadHud.remove()
        self.activityIndicator.remove()
    }
    
    //MARK: - Private methods
    private func addObserverForKeyboardShow() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    private func addObserverForHideKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func setGuiElements() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.textLogoImageView)
        self.view.addSubview(self.modeSegmentedControll)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.passwordTextField)
        
        self.view.addSubview(self.mainSignButton)
        
        self.view.addSubview(self.leftLine)
        self.view.addSubview(self.orLabel)
        self.view.addSubview(self.rightLine)
        self.view.addSubview(self.googleSignInButton)
        self.setUpConstraints()
    }
    
    private func renderSignInButton() {
        self.mainSignButton.titleLabel?.alpha = 0
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.mainSignButton.titleLabel?.alpha = 1
        })
    }
    
    private func resetTextFields() {
        self.emailTextField.text = nil
        self.passwordTextField.text = nil
    }
    
    private func makeRegistration() {
        self.viewModel.signUp(with: self.emailTextField.text,
                              and: self.passwordTextField.text)
    }
    
    private func makeSignIn() {
        self.viewModel.signIn(with: self.emailTextField.text,
                              and: self.passwordTextField.text)
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                    constant: DTEdgeInsets.medium.top),
            self.logoImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                                      multiplier: 1/3),
            self.logoImageView.heightAnchor.constraint(equalTo: self.logoImageView.widthAnchor),
            self.logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.textLogoImageView.topAnchor.constraint(lessThanOrEqualTo: self.logoImageView.bottomAnchor,
                                                        constant: DTEdgeInsets.medium.top),
            self.textLogoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.textLogoImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                                          multiplier: 0.5),
            self.textLogoImageView.heightAnchor.constraint(equalTo: self.textLogoImageView.widthAnchor,
                                                           multiplier: 1/3)
        ])
        
        NSLayoutConstraint.activate([
            self.modeSegmentedControll.topAnchor.constraint(equalTo: self.textLogoImageView.bottomAnchor,
                                                            constant: DTEdgeInsets.medium.top),
            self.modeSegmentedControll.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                             constant: DTEdgeInsets.large.left),
            self.modeSegmentedControll.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                              constant: DTEdgeInsets.large.right),
            self.modeSegmentedControll.heightAnchor.constraint(equalTo: self.textLogoImageView.heightAnchor,
                                                               multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            self.emailTextField.topAnchor.constraint(equalTo: self.modeSegmentedControll.bottomAnchor,
                                                     constant: DTEdgeInsets.large.top),
            
            self.emailTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                      constant: DTEdgeInsets.medium.left),
            self.emailTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                       constant: DTEdgeInsets.medium.right),
            self.emailTextField.heightAnchor.constraint(equalTo: self.mainSignButton.heightAnchor,
                                                        multiplier: 0.75)
        ])
        
        NSLayoutConstraint.activate([
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor,
                                                        constant: DTEdgeInsets.small.top),
            self.passwordTextField.widthAnchor.constraint(equalTo: self.emailTextField.widthAnchor),
            self.passwordTextField.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor),
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.emailTextField.centerXAnchor)
        ])
        
        let mainSignInButtopTopConstraint = NSLayoutConstraint(item: self.mainSignButton,
                                                               attribute: .top,
                                                               relatedBy: .equal,
                                                               toItem: self.passwordTextField,
                                                               attribute: .bottom,
                                                               multiplier: 1,
                                                               constant: 32)
        mainSignInButtopTopConstraint.priority = UILayoutPriority(rawValue: 750)
        
        NSLayoutConstraint.activate([
            mainSignInButtopTopConstraint,
            self.mainSignButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                      constant: DTEdgeInsets.medium.left),
            self.mainSignButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                       constant: DTEdgeInsets.medium.right),
            self.mainSignButton.heightAnchor.constraint(equalTo: self.mainSignButton.widthAnchor,
                                                        multiplier: 0.2),
            self.mainSignButton.bottomAnchor.constraint(equalTo: self.orLabel.topAnchor,
                                                        constant: DTEdgeInsets.small.bottom)
        ])
        
        NSLayoutConstraint.activate([
            self.orLabel.centerXAnchor.constraint(equalTo: self.mainSignButton.centerXAnchor),
            self.orLabel.heightAnchor.constraint(equalTo: self.mainSignButton.heightAnchor,
                                                 multiplier: 0.3),
            self.orLabel.widthAnchor.constraint(equalTo: self.orLabel.widthAnchor,
                                                multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.leftLine.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                constant: DTEdgeInsets.large.left),
            self.leftLine.rightAnchor.constraint(equalTo: self.orLabel.leftAnchor,
                                                 constant: DTEdgeInsets.medium.right),
            self.leftLine.heightAnchor.constraint(equalToConstant: 1),
            self.leftLine.centerYAnchor.constraint(equalTo: self.orLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.rightLine.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                  constant: DTEdgeInsets.large.right),
            self.rightLine.leftAnchor.constraint(equalTo: self.orLabel.rightAnchor,
                                                 constant: DTEdgeInsets.medium.left),
            self.rightLine.heightAnchor.constraint(equalToConstant: 1),
            self.rightLine.centerYAnchor.constraint(equalTo: self.orLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.googleSignInButton.topAnchor.constraint(equalTo: self.orLabel.bottomAnchor,
                                                         constant: DTEdgeInsets.small.top),
            self.googleSignInButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                          constant: DTEdgeInsets.medium.left),
            self.googleSignInButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                           constant: DTEdgeInsets.medium.right),
            self.googleSignInButton.heightAnchor.constraint(equalTo: self.mainSignButton.heightAnchor),
            self.googleSignInButton.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor,
                                                            constant: DTEdgeInsets.large.bottom)
        ])
    }
    
    //MARK: - Actions
    @objc private func modeSwitched(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.mainSignButton.setTitle(LocalizedString.signIn, for: .normal)
            self.renderSignInButton()
            self.isSignInMode = true
        case 1:
            self.mainSignButton.setTitle(LocalizedString.signUp, for: .normal)
            self.renderSignInButton()
            self.isSignInMode = false
        default:
            break
        }
    }
    
    @objc private func mainSignInButtonPressed(_ sender: DTSystemButton) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        sender.currentTitle == LocalizedString.signIn ? self.makeSignIn() : self.makeRegistration()
    }
    
    @objc private func googleSignInPressed() {
        self.googleSignInButton.unpressed()
        self.viewModel.signInWithGoogle()
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        self.logoImageView.alpha = 1
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        self.view.frame.origin.y = 0 - self.logoImageView.bounds.size.height
        self.logoImageView.alpha = 0
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = textField.tag == 0
            ? LocalizedString.email
            : LocalizedString.password
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension LoginViewController: LoginViewControllerPresenter {
    
    func startSigninIn() {
        self.activityIndicator.showOn(self)
    }
    
    func googleSignInStart() {
        self.activityIndicator.showOn(self)
    }
    
    func succesSignUp() {
        self.showDefaultAlert(
            title: LocalizedString.success,
            message: LocalizedString.successfulRegistration,
            preffedStyle: .alert,
            okTitle: LocalizedString.ok,
            completion: { [weak self] in
                guard let self = self else { return }
                self.resetTextFields()
        })
    }
    
    func failedSignUp(with errorMessage: String) {
        self.showDefaultAlert(title: LocalizedString.alertError,
                              message: errorMessage,
                              preffedStyle: .alert,
                              okTitle: LocalizedString.ok)
    }
    
    func signInSuccesed() {
        let mainTabBarViewController = MainTabBarViewController()
        mainTabBarViewController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarViewController, animated: true, completion: nil)
    }
    
    
    func signInFailed(with errorMessage: String) {
        self.mainSignButton.unpressed()
        self.showDefaultAlert(title: LocalizedString.alertError,
                              message: errorMessage,
                              preffedStyle: .alert,
                              okTitle: LocalizedString.ok)
    }
}
