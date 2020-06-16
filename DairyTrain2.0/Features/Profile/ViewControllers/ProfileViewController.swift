import UIKit
import Firebase

class ProfileViewController: MainTabBarItemVC {
    
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
    
    //DOTO: - system spacing
    private var stackViewSpacing: CGFloat {
        return 16 // UIScreen.main.bounds.height / 56
    }
    
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
    
    private lazy var recomendationButton: DTSystemButton = {
        let button = DTSystemButton(tittle: LocalizedString.recomendations)
        button.addTarget(self, action: #selector(self.recomendationButtonPressed),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button 
    }()
    
    private lazy var statisticButton: DTSystemButton = {
        let button = DTSystemButton(tittle: LocalizedString.statisctics)
        button.addTarget(self, action: #selector(self.statisticsButtonPressed),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var settingButton: DTSystemButton = {
        let button = DTSystemButton(tittle: LocalizedString.setting)
        button.addTarget(self, action: #selector(self.settingButtonpPressed),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signOutButton: DTSystemButton = {
        let button = DTSystemButton(tittle: LocalizedString.signOut)
        button.addTarget(self, action: #selector(self.signtOutButtonPressed),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = self.stackViewSpacing
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.recomendationButton)
        stackView.addArrangedSubview(self.statisticButton)
        stackView.addArrangedSubview(self.settingButton)
        stackView.addArrangedSubview(self.signOutButton)
        return stackView
    }()
    
    private lazy var metricStaclView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = self.stackViewSpacing
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.ageInfoView)
        stackView.addArrangedSubview(self.heightInfoView)
        stackView.addArrangedSubview(self.weightInfoView)
        return stackView
    }()
    
    private lazy var genderAndactivivtyStacView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = self.stackViewSpacing
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.genderInfoView)
        stackView.addArrangedSubview(self.activivtyInfoView)
        return stackView
    }()
    
    private lazy var infoViewsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = self.stackViewSpacing
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.totalTrainInfoView)
        stackView.addArrangedSubview(self.genderAndactivivtyStacView)
        stackView.addArrangedSubview(self.metricStaclView)
        return stackView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpGuiElements()
        self.setUpInfoViewAction()
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
    
    private func showRecomendationAlert() {
        AlertHelper.shared.showDefaultAlert(on: self,
                                            title: LocalizedString.alertError,
                                            message: LocalizedString.fillInDataErrorMessage,
                                            cancelTitle: nil,
                                            okTitle: LocalizedString.ok,
                                            style: .alert,
                                            completion: nil)
    }
    
    private func showSignOutAllert() {
        AlertHelper.shared.showDefaultAlert(on: self,
                                            title: LocalizedString.signOutAlert,
                                            message: LocalizedString.signOutAlerMessage,
                                            cancelTitle: LocalizedString.ok,
                                            okTitle: LocalizedString.quit,
                                            style: .actionSheet,
                                            completion: { [weak self] in
                                                guard let self = self else { return }
                                                self.signOut()
        })
    }
  
    private func setUpGuiElements() {
        self.view.backgroundColor = .black
        self.view.addSubview(self.infoViewsStackView)
        self.view.addSubview(self.buttonStackView)
        self.setUpViewConstraints()
    }
    
    private func pushSettingViewController(with title: String) {
        let settingSectionVC = SettingsSectionVC(with: title)
        self.navigationController?.pushViewController(settingSectionVC, animated: true)
    }
    
    private func pushRecomendationViewController() {
        let recomendationVC = RecomendationsViewController()
        self.navigationController?.pushViewController(recomendationVC, animated: true)
    }
    
    private func signOut() {
        DTSettingManager.shared.deleteUserToken()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let mainLoginVC = LoginViewController()
        mainLoginVC.modalPresentationStyle = .overFullScreen
        self.present(mainLoginVC, animated: true, completion: nil)
    }
    
    //MARK: - Constraints
    private func setUpViewConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.infoViewsStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            self.infoViewsStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            self.infoViewsStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            self.buttonStackView.topAnchor.constraint(equalTo: self.infoViewsStackView.bottomAnchor, constant: 16),
            self.buttonStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            self.buttonStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            self.buttonStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            self.buttonStackView.heightAnchor.constraint(equalTo: self.infoViewsStackView.heightAnchor, multiplier: 0.8)
        ])
    }

    //MARK: - Actions
    @objc private func settingButtonpPressed(_ sender: DTSystemButton) {
        guard let buttonTittle = sender.currentTitle else { return }
        self.pushSettingViewController(with: buttonTittle)
    }
    
    @objc private func statisticsButtonPressed() {
        let commonStatisticsVC = CommonStatisticsVC()
        self.navigationController?.pushViewController(commonStatisticsVC, animated: true)
    }
    
    @objc private func recomendationButtonPressed() {
        self.pushRecomendationViewController()
    }
    
    @objc private func signtOutButtonPressed() {
        self.showSignOutAllert()
    }
}



