import UIKit

protocol LoginViewControllerPresenter: AnyObject {
    func signInSuccesed() //done
    func signInFailed(with errorMessage: String) //done
    
    func startSigninIn()
    
    func failedSignUp(with errorMessage: String) //done
    func succesSignUp() //done
    
    func googleSignInStart() //done
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
        self.viewModel.setUpGooglePresentingViewController(to: self)
        self.setGuiElements()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.downloadHud.remove()
    }
    
    //MARK: - Private methods
    private func setGuiElements() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.textLogoImageView)
        self.view.addSubview(self.modeSegmentedControll)
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

    private func flipMainSignInButton() {
//        UIView.transition(with: self.containerForMainSignInButton,
//                          duration: 0.5,
//                          options: [.transitionFlipFromTop, .allowAnimatedContent],
//                          animations: {},
//                          completion: nil)
        self.mainSignButton.titleLabel?.alpha = 0
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.mainSignButton.titleLabel?.alpha = 1
                       // self.containerForMainSignInButton.alpha = 0
        }, completion: { _ in
//            UIView.animate(withDuration: 0.25,
//                           animations: {
    //                       self.mainSignButton.titleLabel?.alpha = 1
//                           // self.containerForMainSignInButton.alpha = 1
//            }, completion: nil)
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
//            self.emailTextField.topAnchor.constraint(equalTo: self.signUpModeButton.bottomAnchor,
//                                                     constant: DTEdgeInsets.large.top),
            self.emailTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                      constant: DTEdgeInsets.medium.left),
            self.emailTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                       constant: DTEdgeInsets.medium.right),
//            self.emailTextField.heightAnchor.constraint(equalTo: self.signInModeButton.heightAnchor,
//                                                        multiplier: 1.3)
//            self.emailTextField.heightAnchor.constraint(equalTo: self.modeSegmentedControll.heightAnchor,
//            multiplier: 1.3)
            
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
        
        let mainSignInButtopTopConstraint = NSLayoutConstraint(item: self.containerForMainSignInButton,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: self.passwordTextField,
                                   attribute: .bottom,
                                   multiplier: 1,
                                   constant: 32)
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
    @objc private func modeSwitched(_ sender: UISegmentedControl) {
          switch sender.selectedSegmentIndex {
          case 0:
              self.mainSignButton.setTitle(LocalizedString.signIn, for: .normal)
              self.flipMainSignInButton()
              self.isSignInMode = true
          case 1:
              self.mainSignButton.setTitle(LocalizedString.signUp, for: .normal)
              self.flipMainSignInButton()
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
        self.viewModel.signInWithGoogle()
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
        self.downloadHud.showOn(self)
    }
    
    func googleSignInStart() {
        self.downloadHud.showOn(self)
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
        self.showDefaultAlert(title: LocalizedString.alertError,
                              message: errorMessage,
                              preffedStyle: .alert,
                              okTitle: LocalizedString.ok)
    }
}
