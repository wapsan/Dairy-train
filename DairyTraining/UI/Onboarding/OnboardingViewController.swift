import UIKit

final class OnboardingViewController: UIPageViewController {

    //MARK: - Constants
    private struct Constants {
        static let skipButtonHeight: CGFloat = 35
        static let skipButtonWidht: CGFloat = 80
    }
    
    //MARK: - GUI Properties
    private lazy var skipButton: UIButton = {
       let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.backgroundColor = DTColors.controllSelectedColor
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(skipButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Module properties
    private let viewModel: OnboardingViewModelProtocol
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Initialization
    init(viewModel: OnboardingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: [:])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    private func setup() {
        setViewControllers([viewModel.firstViewController],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        delegate = viewModel
        dataSource = viewModel
        setupSkipButton()
    }
    
    private func setupSkipButton() {
        view.addSubview(skipButton)
        NSLayoutConstraint.activate([
            skipButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -32),
            skipButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            skipButton.heightAnchor.constraint(equalToConstant: Constants.skipButtonHeight),
            skipButton.widthAnchor.constraint(equalToConstant: Constants.skipButtonWidht)
        ])
        skipButton.layer.cornerRadius = Constants.skipButtonHeight / 4
    }
    
    //MARK: - Actions
    @objc private func skipButtonAction() {
        viewModel.skipButtonPressed()
    }
}
