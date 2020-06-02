import UIKit
import GoogleSignIn
import Firebase

class MainLoginVC: UIViewController {
    
    //MARK: - GUI Properties
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.mainLogo)
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var textLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.textLogo
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var signInModeButton: DTButton = {
        let button = DTButton(tittle: "Sign In")
        button.addTarget(self, action: #selector(self.signInModeButtonTouched), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var signUpModeButton: DTButton = {
        let button = DTButton(tittle: "Sign Up")
        button.addTarget(self, action: #selector(self.signUpModeButtonTouched), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var emailTextField: DTTextField = {
        let textField = DTTextField(placeholder: "Email")
        textField.tag = 0
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var emailTextFieldWhiteLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var passwordTextField: DTTextField = {
        let textField = DTTextField(placeholder: "Password")       
        textField.tag = 1
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextFieldWhiteLine: UIView = {
           let view = UIView()
           view.backgroundColor = .white
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
    
    lazy var containerForMainSignInButton: UIView = {
        let view = UIView()
        view.addSubview(self.mainSignButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var mainSignButton: DTButton = {
        let button = DTButton(tittle: "Sign In")
        button.addTarget(self, action: #selector(self.mainSignInButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var googleSignInButton: GoogleSignInButton = {
        let button = GoogleSignInButton()
        button.addTarget(self, action: #selector(self.googleSignInPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
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
    
    lazy var leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //MARK: - Private properties
    private var isSignInMode: Bool = true
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpGooglePresentingViewController()
        self.setGuiElements()
        self.setUpSignMode()
        
        print("Loginvc loaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addObserverForGoogleSignedIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserverForGoogleSignedIn()
    }
    
    //MARK: - Private methods
    private func setUpGooglePresentingViewController() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
      
    private func setGuiElements() {
        self.view.backgroundColor = .black
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.textLogoImageView)
        self.view.addSubview(self.signInModeButton)
        self.view.addSubview(self.signUpModeButton)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.emailTextFieldWhiteLine)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.passwordTextFieldWhiteLine)
        self.view.addSubview(self.containerForMainSignInButton)
        self.view.addSubview(self.leftLine)
        self.view.addSubview(self.orLabel)
        self.view.addSubview(self.rightLine)
        self.view.addSubview(self.googleSignInButton)
        self.setUpConstraints()
    }
    
    private func setUpSignMode() {
        if self.isSignInMode {
            self.signInModeButton.pressed()
            self.signUpModeButton.backgroundColor = .gray
        }
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
        let mainTabBarVC = MainTabBarVC()
        mainTabBarVC.modalPresentationStyle = .fullScreen
        self.present(mainTabBarVC, animated: true, completion: nil)
    }
    
    private func addObserverForGoogleSignedIn() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.googleSignedIn),
                                               name: .googleSignIn,
                                               object: nil)
    }
    
    private func removeObserverForGoogleSignedIn() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func registration() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (authDataresult, error) in
            if let _ = authDataresult {
                AlertHelper.shared.showAllertOn(self,
                                                tittle: "Succes",
                                                message: "Successful registration",
                                                cancelTittle: nil,
                                                okTittle: "Ok",
                                                style: .alert,
                                                complition: nil)
                self.resetTextFields()
            } else {
                AlertHelper.shared.showAllertOn(self,
                                                tittle: "Error",
                                                message: error?.localizedDescription ?? "Unexpected error",
                                                cancelTittle: nil,
                                                okTittle: "Ok",
                                                style: .alert,
                                                complition: nil)
            }
        }
    }
    
    private func signIn() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (authDataresult, error) in
            if let result  = authDataresult {
               // print("Succes")
                guard let tokent = result.user.refreshToken else { return }
                userDefaults.set(tokent, forKey: UserTokenKey)
                self.presentMainTabBarViewController()
            } else {
                AlertHelper.shared.showAllertOn(self,
                                                tittle: "Erro",
                                                message: error?.localizedDescription ?? "Unexpected error",
                                                cancelTittle: nil,
                                                okTittle: "Ok",
                                                style: .alert,
                                                complition: nil)
            }
        }
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            self.logoImageView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            self.logoImageView.widthAnchor.constraint(equalTo: self.logoImageView.heightAnchor, multiplier: 1),
            self.logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.textLogoImageView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 8),
            self.textLogoImageView.centerXAnchor.constraint(equalTo: self.logoImageView.centerXAnchor),
            self.textLogoImageView.heightAnchor.constraint(equalTo: self.logoImageView.heightAnchor, multiplier: 0.4),
            self.textLogoImageView.widthAnchor.constraint(equalTo: self.logoImageView.widthAnchor, multiplier: 1.5),
        ])
        
        NSLayoutConstraint.activate([
            self.signInModeButton.topAnchor.constraint(equalTo: self.textLogoImageView.bottomAnchor, constant: 16),
            self.signInModeButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 32),
            self.signInModeButton.rightAnchor.constraint(equalTo: self.signUpModeButton.leftAnchor, constant: -32),
            self.signInModeButton.heightAnchor.constraint(equalTo: self.signInModeButton.widthAnchor, multiplier: 0.25),
        ])
        
        NSLayoutConstraint.activate([
            self.signUpModeButton.centerYAnchor.constraint(equalTo: self.signInModeButton.centerYAnchor),
            self.signUpModeButton.heightAnchor.constraint(equalTo: self.signInModeButton.heightAnchor),
            self.signUpModeButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -32),
            self.signUpModeButton.widthAnchor.constraint(equalTo: self.signInModeButton.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.emailTextField.topAnchor.constraint(equalTo: self.signUpModeButton.bottomAnchor, constant: 32),
            self.emailTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            self.emailTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            self.emailTextField.heightAnchor.constraint(equalTo: self.signInModeButton.heightAnchor, multiplier: 1.3)
        ])
        
        NSLayoutConstraint.activate([
            self.emailTextFieldWhiteLine.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor),
            self.emailTextFieldWhiteLine.widthAnchor.constraint(equalTo: self.emailTextField.widthAnchor),
            self.emailTextFieldWhiteLine.heightAnchor.constraint(equalToConstant: 1),
            self.emailTextFieldWhiteLine.centerXAnchor.constraint(equalTo: self.emailTextField.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextFieldWhiteLine.bottomAnchor, constant: 8),
            self.passwordTextField.widthAnchor.constraint(equalTo: self.emailTextField.widthAnchor, multiplier: 1),
            self.passwordTextField.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor, multiplier: 1),
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.emailTextField.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.passwordTextFieldWhiteLine.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor),
            self.passwordTextFieldWhiteLine.widthAnchor.constraint(equalTo: self.passwordTextField.widthAnchor),
            self.passwordTextFieldWhiteLine.heightAnchor.constraint(equalToConstant: 1),
            self.passwordTextFieldWhiteLine.centerXAnchor.constraint(equalTo: self.passwordTextField.centerXAnchor)
        ])
        
        let mainSignInButtopTopConstraint = NSLayoutConstraint(item: self.containerForMainSignInButton,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: self.passwordTextFieldWhiteLine,
                                   attribute: .bottom,
                                   multiplier: 1,
                                   constant: 64)
        mainSignInButtopTopConstraint.priority = UILayoutPriority(rawValue: 750)
        
        NSLayoutConstraint.activate([
            mainSignInButtopTopConstraint,
            self.containerForMainSignInButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            self.containerForMainSignInButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            self.containerForMainSignInButton.heightAnchor.constraint(equalTo: self.containerForMainSignInButton.widthAnchor, multiplier: 0.2)
        ])
       
        NSLayoutConstraint.activate([
            self.mainSignButton.topAnchor.constraint(equalTo: self.containerForMainSignInButton.topAnchor),
            self.mainSignButton.leftAnchor.constraint(equalTo: self.containerForMainSignInButton.leftAnchor),
            self.mainSignButton.rightAnchor.constraint(equalTo: self.containerForMainSignInButton.rightAnchor),
            self.mainSignButton.bottomAnchor.constraint(equalTo: self.containerForMainSignInButton.bottomAnchor, constant: -5)
        ])
  
        NSLayoutConstraint.activate([
            self.orLabel.topAnchor.constraint(equalTo: self.mainSignButton.bottomAnchor, constant: 8),
            self.orLabel.centerXAnchor.constraint(equalTo: self.mainSignButton.centerXAnchor),
            self.orLabel.heightAnchor.constraint(equalTo: self.mainSignButton.heightAnchor, multiplier: 0.3),
            self.orLabel.widthAnchor.constraint(equalTo: self.orLabel.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.leftLine.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 32),
            self.leftLine.rightAnchor.constraint(equalTo: self.orLabel.leftAnchor, constant: -16),
            self.leftLine.heightAnchor.constraint(equalToConstant: 1),
            self.leftLine.centerYAnchor.constraint(equalTo: self.orLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.rightLine.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -32),
            self.rightLine.leftAnchor.constraint(equalTo: self.orLabel.rightAnchor, constant: 16),
            self.rightLine.heightAnchor.constraint(equalToConstant: 1),
            self.rightLine.centerYAnchor.constraint(equalTo: self.orLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.googleSignInButton.topAnchor.constraint(equalTo: self.orLabel.bottomAnchor, constant: 8),
            self.googleSignInButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            self.googleSignInButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            self.googleSignInButton.heightAnchor.constraint(equalTo: self.mainSignButton.heightAnchor, multiplier: 1),
            self.googleSignInButton.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor, constant: -32)
        ])
    }
    
    //MARK: - Actions
    @objc private func signInModeButtonTouched() {
        if !self.isSignInMode {
            self.signInModeButton.backgroundColor = .red
            self.signInModeButton.pressed()
            self.signUpModeButton.backgroundColor = .lightGray
            self.signUpModeButton.unpressed()
            self.mainSignButton.setTitle("Sign In", for: .normal)
            self.flipMainSignInButton()
            self.isSignInMode = true
        }
    }
    
    @objc private func signUpModeButtonTouched() {
        if self.isSignInMode {
            self.signUpModeButton.backgroundColor = .red
            self.signUpModeButton.pressed()
            self.signInModeButton.backgroundColor = .lightGray
            self.signInModeButton.unpressed()
            self.mainSignButton.setTitle("Create account", for: .normal)
            self.flipMainSignInButton()
            self.isSignInMode = false
        }
    }
    
    @objc private func mainSignInButtonPressed(_ sender: DTButton) {
        if sender.currentTitle == "Sign In" {
            self.signIn()
        } else {
            self.registration()
        }
    }
    
    @objc private func googleSignInPressed() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc private func googleSignedIn() {
        self.presentMainTabBarViewController()
        
    }
    
}

//MARK: - UITextFieldDelegate
extension MainLoginVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = textField.tag == 0 ? "Email" : "Password"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
  
}
