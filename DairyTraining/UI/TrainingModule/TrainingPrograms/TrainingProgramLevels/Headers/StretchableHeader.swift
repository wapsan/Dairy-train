import Foundation
import GSKStretchyHeaderView

final class StretchableHeader: GSKStretchyHeaderView {
    
    
    // MARK: - Types
    enum BackButtonType {
        case close
        case goBack
        
        var image: UIImage? {
            switch  self {
            case .close:
                return UIImage(named: "icon_close")
            case .goBack:
                return UIImage(named: "icon_back")
            }
        }
    }
    
    // MARK: - Setable roperties
    var onBackButtonAction: (() -> Void)?
    
    var backButtonImageType: BackButtonType = .close {
        didSet {
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
        setLabelsAlpha(for: stretchFactor)
        stretchFactor == 0 ? hideImage() : showImage()
    }
    
    // MARK: - Private methods
    private func setup() {
        contentView.addSubview(dublicateTitleLabel)
        contentView.addSubview(imageView)
        imageView.addSubview(titleLabel)
        imageView.addSubview(descriptionLabel)
        contentView.addSubview(backButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),
            titleLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 16),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            descriptionLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(lessThanOrEqualTo: imageView.rightAnchor, constant: -16),
            
            dublicateTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dublicateTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            backButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            backButton.heightAnchor.constraint(equalToConstant: 26),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor)
            
        ])
    }
    
    private func setLabelsAlpha(for stretchFactor: CGFloat) {
        if stretchFactor < 0.5 {
            titleLabel.alpha = 0
            descriptionLabel.alpha = 0
        } else {
            titleLabel.alpha = stretchFactor
            descriptionLabel.alpha = stretchFactor
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
