import UIKit
import Firebase

class ProfileVC: MainTabBarItemVC {
    
    //MARK: - GUI Properties
    private lazy var totalTrainInfoView: TDInfoiView = {
        let view = TDInfoiView(type: .trainCount)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var genderInfoView: TDInfoiView = {
        let view = TDInfoiView(type: .gender)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activivtyInfoView: TDInfoiView = {
        let view = TDInfoiView(type: .activityLevel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ageInfoView: TDInfoiView = {
        let view = TDInfoiView(type: .age)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var heightInfoView: TDInfoiView = {
        let view = TDInfoiView(type: .height)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var weightInfoView: TDInfoiView = {
        let view = TDInfoiView(type: .weight)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var recomendationButton: DTButton = {
        let button = DTButton(tittle: "Recomendations")
        button.addTarget(self, action: #selector(self.recomendationButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button 
    }()
    
    private lazy var statisticButton: DTButton = {
        let button = DTButton(tittle: "Statistic")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var settingButton: DTButton = {
        let button = DTButton(tittle: "Setting")
        button.addTarget(self, action: #selector(self.settingButtonpPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signOutButton: DTButton = {
        let button = DTButton(tittle: "Sign out")
        button.addTarget(self, action: #selector(self.signtOutButtonPressed), for: .touchUpInside)
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
    
     private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffectView = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
 
    
    private var infoViewAllert: DTInfoAlert!

    //MARK: - Private properties
    private var isAllertShown: Bool = false
    
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
    //MARK: DOTO системные расстояния
    private var stackViewSpacing: CGFloat {
        return 16 // UIScreen.main.bounds.height / 56
    }
    
    private var infoViews: [TDInfoiView] {
        return [self.activivtyInfoView, self.genderInfoView, self.ageInfoView, self.heightInfoView, self.weightInfoView]
    }
   
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setUpGuiElements()
        self.setUpInfoViewAction()
        self.setUpVisualEffectView()
    }
    
    //MARK: - Private methods
    private func setUpInfoViewAction() {
        for infoView in self.infoViews {
            infoView.tapped = { (infoViewType) in
                self.showAlertFrom(infoView: infoView)
            }
        }
    }
    
    private func showAlertFrom(infoView: TDInfoiView) {
        guard !self.isAllertShown else { return }
        self.infoViewAllert = .init(with: infoView)
        self.infoViewAllert.delegate = self
        self.isAllertShown = true
        self.view.addSubview(self.infoViewAllert)
        self.infoViewAllert.translatesAutoresizingMaskIntoConstraints = false
        self.activateAllertConstraint()
        self.animateInAlert()
    }
    
    private func hideAllert() {
        self.animateOutAlert()
        self.deactivateAllertConstraint()
        self.setAllertState()
    }
    
    private func showRecomendationAlert() {
        AlertHelper.shared.showDefaultAlert(on: self,
                                            title: "Error",
                                            message: "Fill up field to get supply recomendations.",
                                            cancelTitle: nil,
                                            okTitle: "Ok",
                                            style: .alert,
                                            completion: nil)
    }
    
    private func showSignOutAllert() {
        AlertHelper.shared.showDefaultAlert(on: self,
                                            title: "Sign out?",
                                            message: "Are you shure",
                                            cancelTitle: "Cancel",
                                            okTitle: "Quit",
                                            style: .actionSheet,
                                            completion: self.signOut)
    }

    private func animateInAlert() {
        self.infoViewAllert.transform = .init(scaleX: 1.3, y: 1.3)
        self.infoViewAllert.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.alpha = 1
            self.infoViewAllert.alpha = 1
            self.infoViewAllert.transform = CGAffineTransform.identity
        })
    }
    
    private func animateOutAlert() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.infoViewAllert.alpha = 0
                        self.infoViewAllert.transform = .init(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.infoViewAllert.removeFromSuperview()
        }
    }
    
    private func setAllertState() {
        guard self.isAllertShown else { return }
        self.isAllertShown = false
    }
    
    private func setUpVisualEffectView() {
        self.view.addSubview(self.visualEffectView)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.visualEffectView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.visualEffectView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.visualEffectView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.visualEffectView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
        self.visualEffectView.alpha = 0
    }
    
    private func setCostumerInfo() -> CostumerInfo? {
        guard let age = self.ageInfoView.valueLabel.text,
            let height = self.heightInfoView.valueLabel.text,
            let weight = self.weightInfoView.valueLabel.text,
            let gender = self.genderInfoView.valueLabel.text,
            let activityLevel = self.activivtyInfoView.valueLabel.text else { return nil }
        guard self.isAllInfoWasSeted else { return nil }
        let info = CostumerInfo(age: age,
                                height: height,
                                weight: weight,
                                gender: gender,
                                activityLevel: activityLevel)
        return info
    }
    
    private func setUpGuiElements() {
        self.view.addSubview(self.infoViewsStackView)
        self.view.addSubview(self.buttonStackView)
        self.setUpViewConstraints()
    }
    
    private func pushSettingViewController(with title: String) {
        let settingSectionVC = SettingsSectionVC(with: title)
        self.navigationController?.pushViewController(settingSectionVC, animated: true)
    }
    
    private func pushRecomendationViewController() {
        guard let customerInfo = self.setCostumerInfo() else { self.showRecomendationAlert(); return }
        let recomendationVC = RecomendationsViewController()
        recomendationVC.setCustomerInfo(customerInfo)
        self.navigationController?.pushViewController(recomendationVC, animated: true)
    }
    
    private func signOut() {
        userDefaults.removeObject(forKey: UserTokenKey)
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let mainLoginVC = MainLoginVC()
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
    
    private func activateAllertConstraint() {
        NSLayoutConstraint.activate([
            self.infoViewAllert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.infoViewAllert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -32),
            self.infoViewAllert.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            self.infoViewAllert.heightAnchor.constraint(equalTo: self.infoViewAllert.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func deactivateAllertConstraint() {
        NSLayoutConstraint.deactivate([
            self.infoViewAllert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.infoViewAllert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -32),
            self.infoViewAllert.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            self.infoViewAllert.heightAnchor.constraint(equalTo: self.infoViewAllert.widthAnchor, multiplier: 0.9)
        ])
    }
    
    //MARK: - Actions
    @objc private func settingButtonpPressed(_ sender: DTButton) {
        guard let buttonTittle = sender.currentTitle else { return }
        self.pushSettingViewController(with: buttonTittle)
    }
    
    @objc private func recomendationButtonPressed() {
        self.pushRecomendationViewController()
    }
    
    @objc private func signtOutButtonPressed() {
        self.showSignOutAllert()
    }
    
}

//MARK: - DTTestCustomAllerDelegate
extension ProfileVC: DTInfoAllerDelegate {
    
    func okPressed(with alertType: TDInfoiView.InfoViewType) {
        for infoView in self.infoViews {
            guard let infoViewType = infoView.type else { return }
            if infoViewType == alertType {
                switch alertType {
                case .trainCount:
                    infoView.valueLabel.text = UserModel.shared.displayTrainCount
                case .gender:
                    infoView.valueLabel.text = UserModel.shared.displayGender
                case .activityLevel:
                    infoView.valueLabel.text = UserModel.shared.displayActivityLevel
                case .age:
                    infoView.valueLabel.text = UserModel.shared.displayAge
                case .height:
                    infoView.valueLabel.text = UserModel.shared.displayHeight
                case .weight:
                    infoView.valueLabel.text = UserModel.shared.displayWeight
                }
            }
        }
        self.hideAllert()
    }
    
    func cancelTapped() {
        self.hideAllert()
    }
    
}


