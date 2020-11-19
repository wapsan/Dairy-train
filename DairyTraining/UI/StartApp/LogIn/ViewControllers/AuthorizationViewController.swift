import UIKit

class AuthorizationViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet var authorizationButtonsStackView: UIStackView!
    
    // MARK: - GUI Properties
    private lazy var googleSignInButton: Authorizationbutton = {
        let button = Authorizationbutton(type: .google)
        button.addTarget(self,
                         action: #selector(googleSignInButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var facebookLoginButton: Authorizationbutton = {
        let button = Authorizationbutton(type: .facebook)
        button.addTarget(self,
                         action: #selector(facebookLoginButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var appleLoginButton: Authorizationbutton = {
        let button = Authorizationbutton(type: .apple)
        button.addTarget(self,
                         action: #selector(appleLoginButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Properties
    var viewModel: LoginViewModelInput?
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        viewModel?.setUpGooglePresentingViewController()
        fillButtonStackView()
    }
    
    private func fillButtonStackView() {
        authorizationButtonsStackView.addArrangedSubview(googleSignInButton)
        authorizationButtonsStackView.addArrangedSubview(facebookLoginButton)
        authorizationButtonsStackView.addArrangedSubview(appleLoginButton)
    }
    
    // MARK: - Action
    @objc private func googleSignInButtonAction() {
        viewModel?.signInWithGoogle()
    }
    
    @objc private func facebookLoginButtonAction() {
        viewModel?.signInWithFacebook()
    }
    
    @objc private func appleLoginButtonAction() {
        viewModel?.signInWithApple()
    }
}

//MARK: - LoginViewControllerPresenter
extension AuthorizationViewController: LoginViewControllerPresenter {
    func signInSuccesed() {
        MainCoordinator.shared.coordinate(to: MainCoordinator.Target.mainFlow)
    }
    
    func signInFailed(with errorMessage: String) {
        
    }
    
    func startSigninIn() {
        
    }
    
    func failedSignUp(with errorMessage: String) {
        
    }
    
    func succesSignUp() {
        
    }
    
    func googleSignInStart() {
        
    }
}
