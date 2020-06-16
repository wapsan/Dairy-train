import UIKit

protocol DTRecomendationHeaderViewDelegate: class {
    func moreInfoButtonPressed(_ sender: UIButton)
}

class DTRecomendationHeaderView: UIView {
    
    //MARK: - Delegates properties
    weak var delegate: DTRecomendationHeaderViewDelegate?
    
    //MARK: - Private properties
    private var moreInfobuttonIsTouched: Bool = false
    
    //MARK: - GUI Properties
    private lazy var tittle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var moreInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.downArrow, for: .normal)
        button.addTarget(self, action: #selector(self.openInfoButtonPressed(_:)),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Initialization
    init() {
        super.init(frame: .zero)
        self.initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = .black
        self.addSubview(self.tittle)
        self.addSubview(self.moreInfoButton)
        self.setUpConstraints()
    }
    
    //MARK: - Setter
    func setHeaderView(title: String, and section: Int) {
        self.tittle.text = title
        self.moreInfoButton.tag = section
    }
    
    //MARK: - Private methods
    private func rotateMoreInfoButton() {
        if !moreInfobuttonIsTouched {
            UIView.animate(withDuration: 0.4, animations: {
                self.moreInfoButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.moreInfoButton.transform = CGAffineTransform(rotationAngle: CGFloat(-2 * Double.pi))
            })
        }
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.tittle.topAnchor.constraint(equalTo: self.topAnchor,
                                             constant: 8),
            self.tittle.leftAnchor.constraint(equalTo: self.leftAnchor,
                                              constant: 8),
            self.tittle.rightAnchor.constraint(greaterThanOrEqualTo: self.moreInfoButton.leftAnchor,
                                               constant: -8),
            self.tittle.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            self.moreInfoButton.centerYAnchor.constraint(equalTo: self.tittle.centerYAnchor),
            self.moreInfoButton.heightAnchor.constraint(equalTo: self.tittle.heightAnchor),
            self.moreInfoButton.widthAnchor.constraint(equalTo: self.moreInfoButton.heightAnchor),
            self.moreInfoButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        ])
    }
    
    //MARK: - Actions
    @objc private func openInfoButtonPressed(_ sender: UIButton) {
        if !self.moreInfobuttonIsTouched {
            self.rotateMoreInfoButton()
            self.delegate?.moreInfoButtonPressed(sender)
            self.moreInfobuttonIsTouched = true
        } else {
            self.rotateMoreInfoButton()
            self.delegate?.moreInfoButtonPressed(sender)
            self.moreInfobuttonIsTouched = false
        }
    }
}
