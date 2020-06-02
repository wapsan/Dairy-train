import UIKit
import Firebase

class ProfileViewController: MainTabBarItemVC {
 
    //MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var  infoViews: [DTInfoView]!
    @IBOutlet weak var totalTrain: DTInfoView!
    @IBOutlet weak var heightInfoView: DTInfoView!
    @IBOutlet weak var weightInfoView: DTInfoView!
    @IBOutlet weak var ageInfoView: DTInfoView!
    @IBOutlet weak var genderInfoView: DTInfoView!
    @IBOutlet weak var activityLevelInfoView: DTInfoView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Private properties
    private var customAllert: DTCustomAllertView?
    private var genderAllert: DTGenderAlert!
    private var activityAllert: DTActivityAllert!
    private var signOutAllert: UIAlertController!
    private var recomendationAllert: UIAlertController!
    private var isAllertShown: Bool = false
    
    private var isInfoViewsSet: Bool {
        if  self.ageInfoView.isSet &&
            self.heightInfoView.isSet &&
            self.weightInfoView.isSet &&
            self.activityLevelInfoView.isSet &&
            self.genderInfoView.isSet {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInfoViewsTapped()
        self.heightInfoView.type = .height
        self.weightInfoView.type = .weight
    }
    
    //MARK: - Private methods
    private func setAllertState() {
        guard self.isAllertShown else { return }
        self.isAllertShown = false
    }
    
    private func setInfoViewsTapped() {
        for infoView in self.infoViews {
            infoView.infoViewTapped = { (tittle) in
                guard !self.isAllertShown else { return }
                switch tittle {
                case "Gender":
                    self.showGenderAllert()
                case "Activity level":
                    self.showActivivtyAllert()
                default:
                    self.showInfoViewAllertWith(tittle)
                }
                self.isAllertShown = true
            }
        }
    }
    
    private func showGenderAllert() {
        self.genderAllert = .init(on: self.view)
        self.genderAllert.delegate = self
        self.view.addSubview(self.genderAllert)
        self.genderAllert.show()
    }
    
    private func showActivivtyAllert() {
        self.activityAllert = .init(on: self.view)
        self.activityAllert.delegate = self
        self.view.addSubview(self.activityAllert)
        self.activityAllert.show()
    }
    
    private func showInfoViewAllertWith(_ tittle: String) {
        self.customAllert = .init(on: self.view)
        self.customAllert?.delegate = self
        guard let customAllert = self.customAllert else { return }
        self.view.addSubview(customAllert)
        self.customAllert?.showWith(tittle)
    }
  
    private func signOut() {
        userDefaults.removeObject(forKey: UserTokenKey)
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
      //  guard let navigationController = self.navigationController else { return }
        print("")
      //  self.dismiss(animated: true, completion: nil)
      //  let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      //  let signInVC = mainStoryboard.instantiateViewController(identifier: "SignInView")
      //  navigationController.pushViewController(signInVC, animated: true)
    }
    
    private func showSignOutAllert() {
        AlertHelper.shared.showAllertOn(self,
                                        tittle: "Sign in?",
                                        message: "Are you shure",
                                        cancelTittle: "Cancel",
                                        okTittle: "Quit",
                                        style: .actionSheet,
                                        complition: self.signOut)
    }
    
    private func showRecomendationAlert() {
        AlertHelper.shared.showAllertOn(self,
                                        tittle: "Error",
                                        message: "Fill up field to get supply recomendations.",
                                        cancelTittle: nil,
                                        okTittle: "Ok",
                                        style: .alert,
                                        complition: nil)
    }
    
    private func setCostumerInfo() -> CostumerInfo? {
        guard let age = self.ageInfoView.valueLabel.text,
            let height = self.heightInfoView.valueLabel.text,
            let weight = self.weightInfoView.valueLabel.text,
            let gender = self.genderInfoView.valueLabel.text,
            let activityLevel = self.activityLevelInfoView.valueLabel.text else { return nil }
        guard self.isInfoViewsSet else { return nil }
        let info = CostumerInfo(age: age,
                                height: height,
                                weight: weight,
                                gender: gender,
                                activityLevel: activityLevel)
        return info
    }
    
    //MARK: - @IBActions
//    @IBAction func setiingButtonTouched(_ sender: DTStyleButton) {
//        guard let senderTittle = sender.currentTitle else { return }
//        let settingVC = SettingsSectionVC(with: senderTittle)
//        self.navigationController?.pushViewController(settingVC, animated: true)
//    }
    
//    @IBAction func recomendationButtonTouched(_ sender: DTStyleButton) {
//        guard let customerInfo = self.setCostumerInfo() else { self.showRecomendationAlert(); return }
//        
//        if let recomendationVC = self.storyboard?.instantiateViewController(identifier: "Recomendations") as? RecomendationsViewController  {
//            recomendationVC.navigationItem.title = "Recomendations"
//            CaloriesCalculator.shared.setParametersBy(data: customerInfo)
//            self.navigationController?.pushViewController(recomendationVC, animated: true)
//        }
//    }
//    
//    @IBAction func signOutTouched(_ sender: DTStyleButton) {
//        self.showSignOutAllert()
//    }
    
}

//MARK: - CustomAllert Delegate
extension ProfileViewController: CustomAllertDelegate {
    
    func getInfoFromCustomAllert(_ tittle: String, and info: Double) {
        switch tittle {
        case "Set Age":
            self.ageInfoView.valueLabel.text = String(format: "%.0f", info)
        case "Set Weight":
            self.weightInfoView.valueLabel.text = String(format: "%.1f", info)
        case "Set Height":
            self.heightInfoView.valueLabel.text = String(format: "%.1f", info)
        default:
            break
        }
    }
    
    func customAllertOkTapped() {
        self.customAllert?.removeFromSuperview()
        self.setAllertState()
        self.customAllert = nil
    }
    
    func customAllertCnacelTapped() {
        self.customAllert?.removeFromSuperview()
        self.setAllertState()
        self.customAllert = nil
    }
    
}

//MARK: - GenderAllert Delegate
extension ProfileViewController: GenderAllertDelegate {
    
    func genderAllertOkTapped() {
        self.genderAllert.removeFromSuperview()
         self.setAllertState()
    }
    
    func genderAllertCancelTapped() {
        self.genderAllert.removeFromSuperview()
        self.setAllertState()
    }

    func writeGender(_ gender: String) {
        self.genderInfoView.valueLabel.text = gender
    }
    
}

//MARK: - Activityallert delegate
extension ProfileViewController: ActivityAllertDelegate {
    
    func activityAllertOkTapped() {
        self.activityAllert.removeFromSuperview()
        self.setAllertState()
    }
    
    func activityAllertCancelTapped() {
        self.activityAllert.removeFromSuperview()
        self.setAllertState()
    }
    
    func writeActivivtyLeve(_ activityLevel: String) {
        self.activityLevelInfoView.valueLabel.text = activityLevel
    }
    
}
