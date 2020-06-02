import UIKit

class GoogleSignInButton: DTButton {
    
    //MARK: - GUI Properties
    lazy var googleImage: UIImageView = {
        let imageView = UIImageView(image: UIImage.googleImage)
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var googleButtonTittle: UILabel = {
        let label = UILabel()
        label.text = "Sign in with Google"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    lazy var googleStackView: UIStackView = {
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
            self.googleStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.googleStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.googleStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.googleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            self.googleImage.heightAnchor.constraint(equalTo: self.googleImage.widthAnchor)
        ])
    }
    
}
