import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - Private properties
    private lazy var isSignInMode: Bool = true
    
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - GUI Properties
    private lazy var downloadHud: DTDownloadHud = {
        let downloadHud = DTDownloadHud(frame: .zero)
        downloadHud.translatesAutoresizingMaskIntoConstraints = false
        return downloadHud
    }()
    
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
    
    private lazy var signInModeButton: DTSystemButton = {
        let button = DTSystemButton(tittle: LocalizedString.signIn )
        button.addTarget(self,
                         action: #selector(self.signInModeButtonTouched),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signUpModeButton: DTSystemButton = {
        let button = DTSystemButton(tittle: LocalizedString.signUp)
        button.addTarget(self,
                         action: #selector(self.signUpModeButtonTouched),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

    private lazy var containerForMainSignInButton: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpGooglePresentingViewController()
        self.setGuiElements()
        self.setUpSignMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addObserverForGoogleSignedIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserverForGoogleSignedIn()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.downloadHud.remove()
    }
    
    //MARK: - Private methods
    private func setUpGooglePresentingViewController() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
      
    private func setGuiElements() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.textLogoImageView)
        self.view.addSubview(self.signInModeButton)
        self.view.addSubview(self.signUpModeButton)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.containerForMainSignInButton)
        self.containerForMainSignInButton.addSubview(self.mainSignButton)
        
        self.view.addSubview(self.leftLine)
        self.view.addSubview(self.orLabel)
        self.view.addSubview(self.rightLine)
        self.view.addSubview(self.googleSignInButton)
        self.setUpConstraints()
    }
    
    private func setUpSignMode() {
        guard self.isSignInMode else { return }
        self.signInModeButton.pressed()
        self.signUpModeButton.backgroundColor = .gray
    }
    
    private func flipMainSignInButton() {
        UIView.transition(with: self.containerForMainSignInButton,
                          duration: 0.5,
                          options: [.transitionFlipFromTop, .allowAnimatedContent],
                          animations: {},
                          completion: nil)
    }
    
    private func resetTextFields() {
        self.emailTextField.text = nil
        self.passwordTextField.text = nil
    }
    
    private func presentMainTabBarViewController() {
        DTFirebaseFileManager.shared.synhronizeDataFromServer { [weak self] (mainData, trainingList, dateOfUpdate) in
            guard let self = self else { return }
            if let mainData = mainData {
                CoreDataManager.shared.updateUserMainInfo(to: mainData)
            }
            CoreDataManager.shared.updateDateOfLastUpdateTo(dateOfUpdate)
            CoreDataManager.shared.updateUserTrainInfoFrom(trainingList)
            let mainTabBarVC = MainTabBarViewController()
            mainTabBarVC.modalPresentationStyle = .fullScreen
            self.present(mainTabBarVC, animated: true, completion: nil)
        }
    }
    
    private func addObserverForGoogleSignedIn() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.googleSignedIn),
                                               name: .googleSignIn,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.googleStartSigningIn),
                                               name: .startGoogleSignIn,
                                               object: nil)
    }
    
    private func removeObserverForGoogleSignedIn() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func makeRegistration() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (authDataresult, error) in
            if let _ = authDataresult {
                AlertHelper.shared.showDefaultAlert(on: self,
                                                    title: LocalizedString.success,
                                                    message: LocalizedString.successfulRegistration,
                                                    cancelTitle: nil,
                                                    okTitle: LocalizedString.ok,
                                                    style: .alert,
                                                    completion: nil)
                self.resetTextFields()
            } else {
                AlertHelper.shared.showDefaultAlert(on: self,
                                                    title: LocalizedString.alertError,
                                                    message: error?.localizedDescription ?? LocalizedString.unknownError,
                                                    cancelTitle: nil,
                                                    okTitle: LocalizedString.ok,
                                                    style: .alert,
                                                    completion: nil)
            }
        }
    }
    
    private func makeSignIn() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authDataresult, error) in
            guard let self = self else { return }
            if let result  = authDataresult {
                guard let tokent = result.user.refreshToken else { return }
                DTSettingManager.shared.setUserToken(to: tokent)
                self.downloadHud.showOn(self)
                self.presentMainTabBarViewController()
            } else {
                AlertHelper.shared.showDefaultAlert(on: self,
                                                    title: LocalizedString.alertError,
                                                    message: error?.localizedDescription ?? LocalizedString.unknownError,
                                                    cancelTitle: nil,
                                                    okTitle: LocalizedString.ok,
                                                    style: .alert,
                                                    completion: nil)
            }
        }
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                    constant: DTEdgeInsets.medium.top),
            self.logoImageView.heightAnchor.constraint(equalTo: safeArea.heightAnchor,
                                                       multiplier: 0.2),
            self.logoImageView.widthAnchor.constraint(equalTo: self.logoImageView.heightAnchor),
            self.logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.textLogoImageView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor,
                                                        constant: DTEdgeInsets.small.top),
            self.textLogoImageView.centerXAnchor.constraint(equalTo: self.logoImageView.centerXAnchor),
            self.textLogoImageView.heightAnchor.constraint(equalTo: self.logoImageView.heightAnchor,
                                                           multiplier: 0.4),
            self.textLogoImageView.widthAnchor.constraint(equalTo: self.logoImageView.widthAnchor,
                                                          multiplier: 1.5),
        ])
        
        NSLayoutConstraint.activate([
            self.signInModeButton.topAnchor.constraint(equalTo: self.textLogoImageView.bottomAnchor,
                                                       constant: DTEdgeInsets.medium.top),
            self.signInModeButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                        constant: DTEdgeInsets.large.left),
            self.signInModeButton.rightAnchor.constraint(equalTo: self.signUpModeButton.leftAnchor,
                                                         constant: DTEdgeInsets.large.right),
            self.signInModeButton.heightAnchor.constraint(equalTo: self.signInModeButton.widthAnchor,
                                                          multiplier: 0.25),
        ])
        
        NSLayoutConstraint.activate([
            self.signUpModeButton.centerYAnchor.constraint(equalTo: self.signInModeButton.centerYAnchor),
            self.signUpModeButton.heightAnchor.constraint(equalTo: self.signInModeButton.heightAnchor),
            self.signUpModeButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                         constant: DTEdgeInsets.large.right),
            self.signUpModeButton.widthAnchor.constraint(equalTo: self.signInModeButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.emailTextField.topAnchor.constraint(equalTo: self.signUpModeButton.bottomAnchor,
                                                     constant: DTEdgeInsets.large.top),
            self.emailTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                      constant: DTEdgeInsets.medium.left),
            self.emailTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                       constant: DTEdgeInsets.medium.right),
            self.emailTextField.heightAnchor.constraint(equalTo: self.signInModeButton.heightAnchor,
                                                        multiplier: 1.3)
        ])
  
        NSLayoutConstraint.activate([
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor,
                                                        constant: DTEdgeInsets.small.top),
            self.passwordTextField.widthAnchor.constraint(equalTo: self.emailTextField.widthAnchor),
            self.passwordTextField.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor),
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.emailTextField.centerXAnchor)
        ])
        
        let mainSignInButtopTopConstraint = NSLayoutConstraint(item: self.containerForMainSignInButton,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: self.passwordTextField,
                                   attribute: .bottom,
                                   multiplier: 1,
                                   constant: 64)
        mainSignInButtopTopConstraint.priority = UILayoutPriority(rawValue: 750)
        
        NSLayoutConstraint.activate([
            mainSignInButtopTopConstraint,
            self.containerForMainSignInButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                                    constant: DTEdgeInsets.medium.left),
            self.containerForMainSignInButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                                     constant: DTEdgeInsets.medium.right),
            self.containerForMainSignInButton.heightAnchor.constraint(equalTo: self.containerForMainSignInButton.widthAnchor,
                                                                      multiplier: 0.2)
        ])
       
        NSLayoutConstraint.activate([
            self.mainSignButton.topAnchor.constraint(equalTo: self.containerForMainSignInButton.topAnchor),
            self.mainSignButton.leftAnchor.constraint(equalTo: self.containerForMainSignInButton.leftAnchor),
            self.mainSignButton.rightAnchor.constraint(equalTo: self.containerForMainSignInButton.rightAnchor),
            self.mainSignButton.bottomAnchor.constraint(equalTo: self.containerForMainSignInButton.bottomAnchor,
                                                        constant: -5)
        ])
  
        NSLayoutConstraint.activate([
            self.orLabel.topAnchor.constraint(equalTo: self.mainSignButton.bottomAnchor,
                                              constant: DTEdgeInsets.small.top),
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
    @objc private func signInModeButtonTouched() {
        guard !self.isSignInMode else { return }
        self.signInModeButton.backgroundColor = .red
        self.signInModeButton.pressed()
        self.signUpModeButton.backgroundColor = .lightGray
        self.signUpModeButton.unpressed()
        self.mainSignButton.setTitle(LocalizedString.signIn, for: .normal)
        self.flipMainSignInButton()
        self.isSignInMode = true
    }
    
    @objc private func signUpModeButtonTouched() {
        guard self.isSignInMode else { return }
        self.signUpModeButton.backgroundColor = .red
        self.signUpModeButton.pressed()
        self.signInModeButton.backgroundColor = .lightGray
        self.signInModeButton.unpressed()
        self.mainSignButton.setTitle(LocalizedString.createAccount, for: .normal)
        self.flipMainSignInButton()
        self.isSignInMode = false
    }
    
    @objc private func mainSignInButtonPressed(_ sender: DTSystemButton) {
        sender.currentTitle == LocalizedString.signIn ? self.makeSignIn() : self.makeRegistration()
    }
    
    @objc private func googleSignInPressed() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc private func googleSignedIn() {
        self.presentMainTabBarViewController()
    }
    
    @objc private func googleStartSigningIn() {
        self.downloadHud.showOn(self)
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
