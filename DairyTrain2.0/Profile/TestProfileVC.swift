import UIKit
import Firebase

class TestProfileVC: MainTabBarItemVC {
    
    //MARK: - GUI Properties
    lazy var totalTrainInfoView: TESTDTInfoView = {
        let view = TESTDTInfoView(type: .trainCount)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var genderInfoView: TESTDTInfoView = {
        let view = TESTDTInfoView(type: .gender)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var activivtyInfoView: TESTDTInfoView = {
        let view = TESTDTInfoView(type: .activityLevel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ageInfoView: TESTDTInfoView = {
        let view = TESTDTInfoView(type: .age)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var heightInfoView: TESTDTInfoView = {
        let view = TESTDTInfoView(type: .height)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var weightInfoView: TESTDTInfoView = {
        let view = TESTDTInfoView(type: .weight)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var recomendationButton: DTButton = {
        let button = DTButton(tittle: "Recomendations")
        button.addTarget(self, action: #selector(self.recomendationButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button 
    }()
    
    lazy var statisticButton: DTButton = {
        let button = DTButton(tittle: "Statistic")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var settingButton: DTButton = {
        let button = DTButton(tittle: "Setting")
        button.addTarget(self, action: #selector(self.settingButtonpPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var signOutButton: DTButton = {
        let button = DTButton(tittle: "Sign out")
        button.addTarget(self, action: #selector(self.signtOutButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.recomendationButton)
        stackView.addArrangedSubview(self.statisticButton)
        stackView.addArrangedSubview(self.settingButton)
        stackView.addArrangedSubview(self.signOutButton)
        return stackView
    }()
    
    lazy var metricStaclView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.ageInfoView)
        stackView.addArrangedSubview(self.heightInfoView)
        stackView.addArrangedSubview(self.weightInfoView)
        return stackView
    }()
    
    lazy var genderAndactivivtyStacView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.genderInfoView)
        stackView.addArrangedSubview(self.activivtyInfoView)
        return stackView
    }()
    
    lazy var infoViewsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.totalTrainInfoView)
        stackView.addArrangedSubview(self.genderAndactivivtyStacView)
        stackView.addArrangedSubview(self.metricStaclView)
        return stackView
    }()
    
    lazy var visualEffectView: UIVisualEffectView = {
        let blurEffectView = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffectView)
        visualEffectView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        return visualEffectView
    }()
//
    //MARK: - Private properties
    private var isAllertShown: Bool = false
    
    var infoViewAllert: DTTestCustomAllert!
    
    var infoViews: [TESTDTInfoView] {
        return [self.activivtyInfoView, self.genderInfoView, self.ageInfoView, self.heightInfoView, self.weightInfoView]
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setUpGuiElements()
        self.setInfoViewAction()
        self.setUpVisualEffectView()
    }
    
    //MARK: - Private methods
    private func setInfoViewAction() {
        for infoView in self.infoViews {
            infoView.tapped = { (infoViewType) in
                self.showInfoViewAllert(with: infoViewType)
                self.animateInAlert()
            }
        }
    }
    
    private func showInfoViewAllert(with type: TESTDTInfoView.InfoViewType) {
        guard !self.isAllertShown else { return }
        self.infoViewAllert = .init(type: type)
        self.view.addSubview(self.infoViewAllert)
        self.infoViewAllert.translatesAutoresizingMaskIntoConstraints = false
        self.infoViewAllert.delegate = self
        self.isAllertShown = true
        self.activateAllertConstraint()
    }
    
    private func animateInAlert() {
        self.infoViewAllert.transform = .init(scaleX: 1.3, y: 1.3)
        self.infoViewAllert.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.alpha = 1
            self.infoViewAllert.alpha = 1
            self.infoViewAllert.transform = CGAffineTransform.identity
        })
    }
    
    private func animateOutAlert() {
        UIView.animate(withDuration: 0.4,
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
    
//    private func setCostumerInfo() -> CostumerInfo? {
//        guard let age = self.ageInfoView.valueLabel.text,
//            let height = self.heightInfoView.valueLabel.text,
//            let weight = self.weightInfoView.valueLabel.text,
//            let gender = self.genderInfoView.valueLabel.text,
//            let activityLevel = self.activityLevelInfoView.valueLabel.text else { return nil }
//        guard self.isInfoViewsSet else { return nil }
//        let info = CostumerInfo(age: age,
//                                height: height,
//                                weight: weight,
//                                gender: gender,
//                                activityLevel: activityLevel)
//        return info
//    }
    
    private func setUpGuiElements() {
        self.view.addSubview(self.infoViewsStackView)
        self.view.addSubview(self.buttonStackView)
        self.setUpViewConstraints()
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
    
    private func showSignOutAllert() {
        AlertHelper.shared.showAllertOn(self,
                                        tittle: "Sign out?",
                                        message: "Are you shure",
                                        cancelTittle: "Cancel",
                                        okTittle: "Quit",
                                        style: .actionSheet,
                                        complition: self.signOut)
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
        let settingSectionVC = SettingsSectionVC(with: buttonTittle)
        self.navigationController?.pushViewController(settingSectionVC, animated: true)
    }
    
    @objc private func recomendationButtonPressed(_ sender: DTButton) {
        let recomendationVC = RecomendationsViewController()
        self.navigationController?.pushViewController(recomendationVC, animated: true)
    }
    
    @objc private func signtOutButtonPressed(_ sender: DTButton) {
        self.showSignOutAllert()
    }
    
}

//MARK: - DTTestCustomAllerDelegate
extension TestProfileVC: DTTestCustomAllerDelegate {
    
    func okPressed(with alertType: TESTDTInfoView.InfoViewType, and writtenInfo: String) {
        for infoView in self.infoViews {
            if infoView.type == alertType {
                infoView.valueLabel.text = writtenInfo
            }
        }
      //  self.infoViewAllert.removeFromSuperview()
        self.animateOutAlert()
        self.deactivateAllertConstraint()
        self.setAllertState()
    }
    
    func cancelTapped() {
      //  self.infoViewAllert.removeFromSuperview()
        self.animateOutAlert()
        self.deactivateAllertConstraint()
        self.setAllertState()
    }
    
}


