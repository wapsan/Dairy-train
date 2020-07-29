import UIKit

protocol ProfileViewPresenter: AnyObject {
    func showRecomendationAlert()
    func showMenu()
    func showSignOutAlert()
    func presentLoginViewController()
    func showErrorSignOutAlert(with error: Error)
}

final class ProfileViewController: MainTabBarItemVC {
    
    //MARK: - Properties
    var viewModel: ProfileViewModel!
    
    //MARK: - Private properties
    private var isAllInfoWasSeted: Bool {
        if self.ageInfoView.isValueSeted,
            self.heightInfoView.isValueSeted,
            self.weightInfoView.isValueSeted,
            self.genderInfoView.isValueSeted,
            self.activivtyInfoView.isValueSeted {
            return true
        } else {
            return false
        }
    }
    
    private lazy var stackViewSpacing: CGFloat = 16
    
    private var infoViews: [DTInfoView] {
        return [self.activivtyInfoView,
                self.genderInfoView,
                self.ageInfoView,
                self.heightInfoView,
                self.weightInfoView]
    }
    
    //MARK: - GUI Properties
    private lazy var totalTrainInfoView: DTInfoView = {
        let view = DTInfoView(type: .trainCount)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var genderInfoView: DTInfoView = {
        let view = DTInfoView(type: .gender)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activivtyInfoView: DTInfoView = {
        let view = DTInfoView(type: .activityLevel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ageInfoView: DTInfoView = {
        let view = DTInfoView(type: .age)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var heightInfoView: DTInfoView = {
        let view = DTInfoView(type: .height)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var weightInfoView: DTInfoView = {
        let view = DTInfoView(type: .weight)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var totalTrainActivityLevelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.totalTrainInfoView)
        stackView.addArrangedSubview(self.activivtyInfoView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var gennderAgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.genderInfoView)
        stackView.addArrangedSubview(self.ageInfoView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var weightHeightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.heightInfoView)
        stackView.addArrangedSubview(self.weightInfoView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpGuiElements()
        self.setUpInfoViewAction()
        self.setUpMenuButtonBar()
    }
    
    //MARK: - Private methods
    private func setUpInfoViewAction() {
        for infoView in self.infoViews {
            infoView.tapped = { [weak self] (infoViewType) in
                guard let self = self else { return }
                DTCustomAlert.shared.showInfoAlert(on: self, with: infoView)
            }
        }
    }
    
    private func setUpGuiElements() {
        self.view.backgroundColor = .black
        self.view.addSubview(self.totalTrainActivityLevelStackView)
        self.view.addSubview(self.gennderAgeStackView)
        self.view.addSubview(self.weightHeightStackView)
        self.setUpConstraints()
    }
    
    private func setUpMenuButtonBar() {
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.menuButtonPressed))
        self.navigationItem.rightBarButtonItem = menuButton
    }

    //MARK: - Constraints
    private func setUpConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.totalTrainActivityLevelStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                                       constant: DTEdgeInsets.medium.top),
            self.totalTrainActivityLevelStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                                        constant: DTEdgeInsets.medium.left),
            self.totalTrainActivityLevelStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                                         constant: DTEdgeInsets.medium.right),
        ])
        
        NSLayoutConstraint.activate([
            self.gennderAgeStackView.topAnchor.constraint(equalTo: self.totalTrainActivityLevelStackView.bottomAnchor,
                                                          constant: DTEdgeInsets.medium.top),
            self.gennderAgeStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                           constant: DTEdgeInsets.medium.left),
            self.gennderAgeStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                            constant: DTEdgeInsets.medium.right),
            self.gennderAgeStackView.heightAnchor.constraint(equalTo: self.totalTrainActivityLevelStackView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.weightHeightStackView.topAnchor.constraint(equalTo: self.gennderAgeStackView.bottomAnchor,
                                                            constant: DTEdgeInsets.medium.top),
            self.weightHeightStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                             constant: DTEdgeInsets.medium.left),
            self.weightHeightStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                              constant: DTEdgeInsets.medium.right),
            self.weightHeightStackView.heightAnchor.constraint(equalTo: self.gennderAgeStackView.heightAnchor),
            self.weightHeightStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                               constant: DTEdgeInsets.medium.bottom)
        ])
    }
    
    //MARK: - Actions
    @objc private func menuButtonPressed() {
        self.showMenu()
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension ProfileViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return MenuPresentationViewController(presentedViewController: presented,
                                              presenting: presenting)
    }
}

//MARK: - ProfileViewPresenter
extension ProfileViewController: ProfileViewPresenter {
    
    func showRecomendationAlert() {
        self.showDefaultAlert(title: LocalizedString.alertError,
                              message: LocalizedString.fillInDataErrorMessage,
                              preffedStyle: .alert,
                              okTitle: LocalizedString.ok)
    }
    
    func showMenu() {
        let menuStackViewController = MenuViewController()
        menuStackViewController.modalPresentationStyle = .custom
        menuStackViewController.transitioningDelegate = self
        menuStackViewController.delegate = self
        self.present(menuStackViewController, animated: true, completion: nil)
    }
    
    func showErrorSignOutAlert(with error: Error) {
        self.showDefaultAlert(title: LocalizedString.alertError,
                              message: error.localizedDescription,
                              preffedStyle: .alert,
                              okTitle: LocalizedString.ok)
    }
    
    func showSignOutAlert() {
        self.showDefaultAlert(
            title: LocalizedString.signOutAlert,
            message: LocalizedString.signOutAlerMessage,
            preffedStyle: .actionSheet,
            okTitle: LocalizedString.ok,
            cancelTitle: LocalizedString.cancel,
            completion: { [weak self] in
                guard let self = self else { return }
                self.viewModel.signOut()
        })
    }
    
    func configureLoginViewController() -> LoginViewController {
              let loginViewController = LoginViewController()
              let loginViewModel = LoginViewModel()
              let loginModel = LoginModel()
              loginViewController.viewModel = loginViewModel
              loginViewModel.viewPresenter = loginViewController
              loginViewModel.model = loginModel
              loginModel.delegate = loginViewModel
              return loginViewController
        }
    
    func presentLoginViewController() {
        let mainLoginVC = configureLoginViewController()
        mainLoginVC.modalPresentationStyle = .overFullScreen
        self.present(mainLoginVC, animated: true, completion: nil)
    }
}

//MARK: - MenuStackViewControllerDelegate
extension ProfileViewController: MenuStackViewControllerDelegate {
    
    func signOutPressed() {
        self.showSignOutAlert()
    }
    
    func pushViewController(_ pushedViewController: UIViewController) {
        if pushedViewController is RecomendationsViewController {
            if self.isAllInfoWasSeted {
                self.navigationController?.pushViewController(pushedViewController, animated: true)
            } else {
                self.showRecomendationAlert()
            }
        } else {
            self.navigationController?.pushViewController(pushedViewController, animated: true)
        }
    }
}
