import Foundation
import GSKStretchyHeaderView

final class StretchableHeader: GSKStretchyHeaderView {
        
    // MARK: - Types
    enum BackButtonType {
        case close
        case goBack
        case none
        
        var image: UIImage? {
            switch  self {
            case .close:
                return UIImage(named: "icon_close")
            case .goBack:
                return UIImage(named: "icon_back")
            case .none:
                return nil
            }
        }
    }
    
    // MARK: - Setable roperties
    var onBackButtonAction: (() -> Void)?
    var onCreateTrainingButtonAction: (() -> Void)?
    var onCreatePaternButtonAction: (() -> Void)?
    
    var backButtonImageType: BackButtonType = .close {
        didSet {
            guard backButtonImageType != .none else {
                backButton.isHidden = true
                return
            }
            backButton.setImage(backButtonImageType.image, for: .normal)
        }
    }
    
    var title: String? = nil {
        didSet {
            titleLabel.text = title
            dublicateTitleLabel.text = title
        }
    }
    
    var customDescription: String? = nil {
        didSet {
            descriptionLabel.text = customDescription
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    // MARK: - GUI Properties
    private lazy var dublicateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "totalTraininfoViewBackground")
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(named: "add"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createTrainingButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "addTraining"), for: .normal)
        button.setTitle("Create training", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(createTrainingButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func createTrainingButtonPressed() {
        onCreateTrainingButtonAction?()
    }
    
    private lazy var createPaternButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "addTraining"), for: .normal)
        button.setTitle("Create patern", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(createPaternButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func createPaternButtonPressed() {
        onCreatePaternButtonAction?()
    }
    
    private lazy var createTrainingEntityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.addArrangedSubview(createTrainingButton)
        stackView.addArrangedSubview(createPaternButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(createTrainingEntityStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        super.didChangeStretchFactor(stretchFactor)
        setElementsAlpha(for: stretchFactor)
        stretchFactor == 0 ? hideImage() : showImage()
    }
    
    func showButtons() {
        createTrainingEntityStackView.isHidden = false
    }
    
    private func hideButtons() {
        createTrainingEntityStackView.isHidden = true
    }
    
    // MARK: - Private methods
    private func setup() {
        contentView.addSubview(dublicateTitleLabel)
        contentView.addSubview(imageView)
        imageView.addSubview(mainStackView)
        contentView.addSubview(backButton)
        setupConstraints()
        hideButtons()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            mainStackView.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 16),
            mainStackView.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -16),
            dublicateTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dublicateTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            backButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            backButton.heightAnchor.constraint(equalToConstant: 26),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
           createTrainingEntityStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setElementsAlpha(for stretchFactor: CGFloat) {
        if stretchFactor < 0.5 {
            titleLabel.alpha = 0
            descriptionLabel.alpha = 0
            createTrainingEntityStackView.alpha = 0
        } else {
            titleLabel.alpha = stretchFactor
            descriptionLabel.alpha = stretchFactor
            createTrainingEntityStackView.alpha = stretchFactor
        }
    }
    
    private func hideImage() {
        UIView.animate(withDuration: 0.15, animations: {
            self.imageView.alpha = 0
        })
    }
    
    private func showImage() {
        UIView.animate(withDuration: 0.15, animations: {
            self.imageView.alpha = 1
        })
    }
    
    
    // MARK: - Actions
    @objc private func backButtonPressed() {
        onBackButtonAction?()
    }
}
