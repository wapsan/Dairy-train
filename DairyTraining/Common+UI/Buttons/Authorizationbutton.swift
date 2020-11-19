import UIKit

final class Authorizationbutton: DTSystemButton {
    
    // MARK: - Overrided properties
    override var unpressedBackgroundColor: UIColor {
        return UIColor.white
    }
    
    override var pressedBackgroundColor: UIColor {
        return UIColor.lightGray
    }
    
    // MARK: - Types
    enum AuthorizationButtonType {
        case google
        case facebook
        case apple
        
        var title: String {
            switch self {
            case .google:
                return LocalizedString.signInWithGoogle
            case .facebook:
                return "Login with Facebook"
            case .apple:
                return "Login with Apple"
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .google, .apple:
                return .black
            case .facebook:
                return .black
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .google:
                return .white
            case .facebook:
                return .white
            case .apple:
                return .white
            }
        }
        
        var image: UIImage? {
            switch self {
            case .google:
                return UIImage(named: "googleCustom")
            case .facebook:
                return UIImage(named: "facebookAuthorizationIcon")
            case .apple:
                return UIImage(named: "appleAuthorizationIcon")
            }
        }
    }
    
    private var type: AuthorizationButtonType
    
    //MARK: - GUI Properties
    private lazy var googleImage: UIImageView = {
        let imageView = UIImageView(image: type.image)
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var googleButtonTittle: UILabel = {
        let label = UILabel()
        label.text = type.title
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 1
        label.textColor = type.textColor
        return label
    }()
    
    private lazy var googleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.addArrangedSubview(self.googleImage)
        stackView.addArrangedSubview(self.googleButtonTittle)
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        return stackView
    }()
    
    //MARK: - Initialization
    init(type: AuthorizationButtonType) {
        self.type = type
        super.init(tittle: "")
        self.backgroundColor = type.backgroundColor
        self.addSubview(self.googleStackView)
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.googleStackView.topAnchor.constraint(equalTo: self.topAnchor,
                                                      constant: DTEdgeInsets.small.top),
            self.googleStackView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                       constant: DTEdgeInsets.small.left),
            self.googleStackView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                        constant: DTEdgeInsets.medium.right),
            self.googleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                         constant: DTEdgeInsets.small.bottom),
        ])
        
        NSLayoutConstraint.activate([
            self.googleImage.heightAnchor.constraint(equalTo: self.googleImage.widthAnchor)
        ])
    }
}
