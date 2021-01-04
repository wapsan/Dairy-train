import UIKit

class DTMainInfoCell: UICollectionViewCell {

    
    //MARK: - GUI Properties
    private(set) lazy var valueLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let firstColor = UIColor.black.withAlphaComponent(0.7)
        let secondColor = DTColors.controllUnselectedColor.withAlphaComponent(0.5)
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.locations = [0.0, 0.9]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private lazy var titleLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIScreen.main.bounds.height / 30
        view.layer.borderWidth = 1
        view.layer.borderColor = DTColors.controllBorderColor.cgColor
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var whiteLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.whiteLine)
        stackView.addArrangedSubview(self.valueLabel)
        stackView.addArrangedSubview(self.descriptionLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.containerView.bounds
        
    }
    
    private func initView() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.backgroundImage)
        self.backgroundImage.addSubview(self.coloredView)
        self.coloredView.addSubview(self.containerStackView)
        self.coloredView.layer.insertSublayer(self.gradient, at: 0)
        self.setConstraints()
    }
    
    //MARK: - Public methods
    func renderCell(for index: Int) {
        guard let cellType = ProfileInfoCellType.init(rawValue: index) else { return }
        self.valueLabel.text = cellType.value
        self.descriptionLabel.text = cellType.description
        self.titleLabel.text = cellType.title
        self.backgroundImage.image = cellType.backgroubImage
    }
    
    func updateWeightMode() {
        for cellType in ProfileInfoCellType.allCases {
            if cellType == .weight {
                self.descriptionLabel.text = cellType.description
                               self.valueLabel.text = cellType.value
            }
        }
    }
    
    func upDateHeightMode() {
        for cellType in ProfileInfoCellType.allCases {
            if cellType == .hight {
                self.descriptionLabel.text = cellType.description
                self.valueLabel.text = cellType.value
            }
        }
    }
    
    
    //MARK: - Private properties
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor,
                                                    constant: DTEdgeInsets.small.top),
            self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                     constant: DTEdgeInsets.small.left),
            self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                      constant: DTEdgeInsets.small.right),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                       constant: DTEdgeInsets.small.bottom),
        ])
        
        NSLayoutConstraint.activate([
            self.containerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.containerStackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor,
                                                         constant: DTEdgeInsets.small.top),
            self.containerStackView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                          constant: DTEdgeInsets.medium.left),
            self.containerStackView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                           constant: DTEdgeInsets.medium.right),
            self.containerStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor,
                                                            constant: DTEdgeInsets.small.bottom)
        ])
        
        NSLayoutConstraint.activate([
            self.backgroundImage.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.backgroundImage.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.backgroundImage.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            self.backgroundImage.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.whiteLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.coloredView.topAnchor.constraint(equalTo: self.backgroundImage.topAnchor),
            self.coloredView.leftAnchor.constraint(equalTo: self.backgroundImage.leftAnchor),
            self.coloredView.rightAnchor.constraint(equalTo: self.backgroundImage.rightAnchor),
            self.coloredView.bottomAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor)
            
        ])
    }
}
