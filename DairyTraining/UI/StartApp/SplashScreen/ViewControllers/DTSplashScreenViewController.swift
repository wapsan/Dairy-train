import UIKit

final class DTSplashScreenViewController: UIViewController {

    //MARK: - GUI Properties
    private lazy var mainLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.mainLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.textLogo
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainView()
        presentInitialViewController()
    }
    
    //MARK: - Private methods
    private func setUpMainView() {
        self.view.addSubview(self.mainLogo)
        self.view.addSubview(self.textLogo)
        self.view.backgroundColor = DTColors.backgroundColor
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        self.activateConstraints()
    }
    
    private func presentInitialViewController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            if let _ = SettingManager.shared.getUserToken() {
                MainCoordinator.shared.coordinate(to: TabBarCoordinator.Target.mainTabBar)
            } else {
                MainCoordinator.shared.coordinate(to: AuthorizationCoordinator.Target.authorizationScreen)
            }
        })
    }
   
    //MARK: - Constraints
    private func activateConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.mainLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.mainLogo.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                                 multiplier: 0.5),
            self.mainLogo.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.mainLogo.heightAnchor.constraint(equalTo: self.mainLogo.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.textLogo.topAnchor.constraint(equalTo: self.mainLogo.bottomAnchor,
                                               constant: DTEdgeInsets.medium.top),
            self.textLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textLogo.widthAnchor.constraint(equalTo: self.mainLogo.widthAnchor,
                                                 multiplier: 1.3),
            self.textLogo.heightAnchor.constraint(equalTo: self.mainLogo.heightAnchor,
                                                  multiplier: 0.4),
        ])
    }
}
