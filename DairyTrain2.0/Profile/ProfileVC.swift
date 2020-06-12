import UIKit
import Firebase

class ProfileVC: MainTabBarItemVC {
    
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
    //MARK: DOTO системные расстояния
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
    
    private lazy var recomendationButton: DTButton = {
        let button = DTButton(tittle: "Recomendations")
        button.addTarget(self, action: #selector(self.recomendationButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button 
    }()
    
    private lazy var statisticButton: DTButton = {
        let button = DTButton(tittle: "Statistic")
        button.addTarget(self, action: #selector(self.statisticsButtonPressed), for: .touchUpInside)
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpGuiElements()
        self.setUpInfoViewAction()
    }
    
    //MARK: - Private methods
    private func setUpInfoViewAction() {
        for infoView in self.infoViews {
            infoView.tapped = { (infoViewType) in
                DTCustomAlert.shared.showInfoAlert(on: self, with: infoView)
            }
        }
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
        guard let customerInfo = self.setCostumerInfo() else { self.showRecomendationAlert(); return }
        let recomendationVC = RecomendationsViewController()
        recomendationVC.setCustomerInfo(customerInfo)
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

    //MARK: - Actions
    @objc private func settingButtonpPressed(_ sender: DTButton) {
        guard let buttonTittle = sender.currentTitle else { return }
        self.pushSettingViewController(with: buttonTittle)
    }
    
    @objc private func statisticsButtonPressed() {
//        let statisctics = Statistics(for: UserModel.shared.trains[0])
//        let numberOfSubgroups = statisctics.numberOfTrainedSubgroups
//        let totalAproach = statisctics.totalNumberOfAproach
//        let totalReps = statisctics.totalNumberOfReps
//        let avarageWeight = statisctics.averageProjectileWeight
//        let totalWeight = statisctics.totalWorkoutWeight
//        print("Number of trained grops - \(numberOfSubgroups)")
//        print("Total aproaches - \(totalAproach)")
//        print("Total reps - \(totalReps)")
//        print("Avarage eight - \(avarageWeight)")
//        print("Total weight - \(totalWeight)")
        
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



