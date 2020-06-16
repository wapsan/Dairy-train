import UIKit

protocol DTRecomendationHeaderViewDelegate: class {
    func tapOpenCellsButton(_ sender: UIButton)
}

class DTRecomendationHeaderView: UIView {
    
    //MARK: - Delegates properties
    weak var delegate: DTRecomendationHeaderViewDelegate?
    
    //MARK: - Private properties
    private var moreInfobuttonIsTouched: Bool = false
    
    //MARK: - GUI Properties
    lazy var tittle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var openInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.downArrow, for: .normal)
        button.addTarget(self, action: #selector(self.openInfoButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //MARK: - Initialization
    init() {
        super.init(frame: .zero)
        self.initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func initView() {
        self.backgroundColor = .black
        self.addSubview(self.tittle)
        self.addSubview(self.openInfoButton)
        self.setUpConstraints()
    }
    
    private func rotateMoreInfoButton() {
        if !moreInfobuttonIsTouched {
            UIView.animate(withDuration: 0.4, animations: {
                self.openInfoButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.openInfoButton.transform = CGAffineTransform(rotationAngle: CGFloat(-2 * Double.pi))
            })
        }
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.tittle.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.tittle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.tittle.rightAnchor.constraint(greaterThanOrEqualTo: self.openInfoButton.leftAnchor, constant: -8),
            self.tittle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            self.openInfoButton.centerYAnchor.constraint(equalTo: self.tittle.centerYAnchor),
            self.openInfoButton.heightAnchor.constraint(equalTo: self.tittle.heightAnchor),
            self.openInfoButton.widthAnchor.constraint(equalTo: self.openInfoButton.heightAnchor),
            self.openInfoButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        ])
    }
    
    //MARK: - Actions
    @objc private func openInfoButtonPressed(_ sender: UIButton) {
        if !self.moreInfobuttonIsTouched {
            self.rotateMoreInfoButton()
            self.delegate?.tapOpenCellsButton(sender)
            self.moreInfobuttonIsTouched = true
        } else {
            self.rotateMoreInfoButton()
            self.delegate?.tapOpenCellsButton(sender)
            self.moreInfobuttonIsTouched = false
        }
    }
    
}
