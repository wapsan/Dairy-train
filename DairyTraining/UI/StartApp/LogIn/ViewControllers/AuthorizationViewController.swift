import UIKit
import GoogleSignIn

protocol AuthorizationViewProtocol: AnyObject {
    func signInSuccesed()
    func googleSignInStart()
}

final class AuthorizationViewController: UIViewController, Loadable {

    // MARK: - @IBOutlets
    @IBOutlet private var authorizationButtonsStackView: UIStackView!
    
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
    private let viewModel: LoginViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Initialization
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        fillAuthorizationButtonStackView()
    }
    
    private func fillAuthorizationButtonStackView() {
        authorizationButtonsStackView.addArrangedSubview(googleSignInButton)
        authorizationButtonsStackView.addArrangedSubview(facebookLoginButton)
        authorizationButtonsStackView.addArrangedSubview(appleLoginButton)
    }
    
    // MARK: - Action
    @objc private func googleSignInButtonAction() {
        viewModel.signInWithGoogle()
    }
    
    @objc private func facebookLoginButtonAction() {
        viewModel.signInWithFacebook()
    }
    
    @objc private func appleLoginButtonAction() {
        viewModel.signInWithApple()
    }
}

//MARK: - LoginViewControllerPresenter
extension AuthorizationViewController: AuthorizationViewProtocol {
    
    func signInSuccesed() {
        hideLoader()
    }
    
    func googleSignInStart() {
        showLoader()
    }
}
