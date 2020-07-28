import UIKit

class GoogleSignInButton: DTSystemButton {
    
    override var unpressedBackgroundColor: UIColor {
        return UIColor.white
    }
    
    override var pressedBackgroundColor: UIColor {
        return UIColor.lightGray
    }
    
    //MARK: - GUI Properties
    private lazy var googleImage: UIImageView = {
        let imageView = UIImageView(image: UIImage.googleImage)
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var googleButtonTittle: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.signInWithGoogle
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    private lazy var googleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.addArrangedSubview(self.googleImage)
        stackView.addArrangedSubview(self.googleButtonTittle)
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        return stackView
    }()
    
    //MARK: - Initialization
    init() {
        super.init(tittle: "")
        self.backgroundColor = .white
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
