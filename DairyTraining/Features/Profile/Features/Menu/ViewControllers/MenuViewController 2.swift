import UIKit

//MARK: - Protocol delegate
protocol MenuStackViewControllerDelegate: class {
    func pushViewController(_ pushedViewController: UIViewController)
    func signOutPressed()
}

class MenuViewController: UIViewController {
    
    //MARK: - Delegate Propertie
    weak var delegate: MenuStackViewControllerDelegate?
    
    //MARK: - GUI Properties
    private lazy var menuButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.recomendationButton)
        stackView.addArrangedSubview(self.statisticsButton)
        stackView.addArrangedSubview(self.settingButton)
        stackView.addArrangedSubview(self.signOutButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var signOutButton: DTMenuButton = {
        let menuButton = DTMenuButton()
        menuButton.setTitle(LocalizedString.signOut, for: .normal)
        menuButton.titleLabel?.textAlignment = .left
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self,
                             action: #selector(self.signtOutButtonPressed),
                             for: .touchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        return menuButton
    }()
    
    private lazy var settingButton: DTMenuButton = {
        let menuButton = DTMenuButton()
        menuButton.setTitle(LocalizedString.setting, for: .normal)
        menuButton.titleLabel?.textAlignment = .left
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self,
                             action: #selector(self.settingButtonpPressed(_:)),
                             for: .touchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        return menuButton
    }()
    
    private lazy var statisticsButton: DTMenuButton = {
        let menuButton = DTMenuButton()
        menuButton.setTitle(LocalizedString.statistics, for: .normal)
        menuButton.titleLabel?.textAlignment = .left
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self,
                             action: #selector(self.statisticsButtonPressed),
                             for: .touchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        return menuButton
    }()
    
    
    private lazy var recomendationButton: DTMenuButton = {
        let menuButton = DTMenuButton()
        menuButton.setTitle(LocalizedString.recomendations, for: .normal)
        menuButton.titleLabel?.textAlignment = .left
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self,
                             action: #selector(self.recomendationButtonPressed),
                             for: .touchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        return menuButton
    }()
    
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .viewFlipsideBckgoundColor
        self.view.addSubview(self.topLineView)
        self.view.addSubview(self.menuButtonStackView)
        self.setUpConstraints()
        self.setUpTopLineViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.topLineView.layer.cornerRadius = self.topLineView.bounds.height / 2
    }
    
    //MARK: - Constraints
    private func setUpTopLineViewConstraints() {
        NSLayoutConstraint.activate([
            self.topLineView.topAnchor.constraint(equalTo: self.view.topAnchor,
                                                  constant: DTEdgeInsets.medium.top),
            self.topLineView.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                                    multiplier: 1/10),
            self.topLineView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.topLineView.heightAnchor.constraint(equalTo: self.topLineView.widthAnchor,
                                                     multiplier: 1/10)
        ])
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.menuButtonStackView.topAnchor.constraint(equalTo: self.topLineView.bottomAnchor,
                                                          constant: DTEdgeInsets.medium.top),
            self.menuButtonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.menuButtonStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                                            multiplier: 0.8),
        ])
        
        NSLayoutConstraint.activate([
            self.recomendationButton.heightAnchor.constraint(equalTo: self.view.widthAnchor,
                                                             multiplier: 0.15),
            self.statisticsButton.heightAnchor.constraint(equalTo: self.view.widthAnchor,
                                                          multiplier: 0.15),
            self.settingButton.heightAnchor.constraint(equalTo: self.view.widthAnchor,
                                                       multiplier: 0.15),
            self.signOutButton.heightAnchor.constraint(equalTo: self.view.widthAnchor,
                                                       multiplier: 0.15),
        ])
    }
    
    //MARK: - Actions
    @objc private func settingButtonpPressed(_ sender: DTSystemButton) {
        guard let title = sender.titleLabel?.text else { return }
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.delegate?.pushViewController(SettingsSectionViewController(with: title))
        })
    }
    
    @objc private func statisticsButtonPressed() {
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.delegate?.pushViewController(CommonStatisticsViewController())
        })
    }
    
    @objc private func recomendationButtonPressed() {
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.delegate?.pushViewController(RecomendationsViewController())
        })
    }
    
    @objc private func signtOutButtonPressed() {
        self.view.layer.speed = 1.5
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.delegate?.signOutPressed()
        })
    }
}
