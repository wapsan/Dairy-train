import UIKit

enum InfoViewValueType {
       case trainCount
       case gender
       case activityLevel
       case age
       case height
       case weight
       
       case totalReps
       case totalAproach
       case avarageProjectileWeight
       case totalWeight
}

protocol DTMainInfoViewPresenter: AnyObject {
    func settingWasChanged()
    func updateInfo()
    var type: InfoViewValueType? { get }
}

class DTMainInfoView: UIView {
        
    //MARK: - Private properties
    var viewModel: DTMainInfoViewModel?
    
    //MARK: - GUI Elemnts
    private(set) lazy var valueLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear//.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var containerViewView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIScreen.main.bounds.height / 30 //30
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Properties
    private(set) var _type: InfoViewValueType?
    var tapped: (() -> Void)?
    var isValueSeted: Bool {
        switch self.valueLabel.text {
        case "0","_", "0.0":
            return false
        default:
            return true
        }
    }
    
   
    //MARK: - Initialization
    init(type: InfoViewValueType) {
        super.init(frame: .zero)
        self._type = type
        
        let viewModel = DTMainInfoViewModel()
        let model = DTMainInfoModel()
        self.viewModel = viewModel
        viewModel.view = self
        viewModel.model = model
        model.output = viewModel
        
        self.titleLabel.text = self.viewModel?.title
        self.valueLabel.text = self.viewModel?.value
        self.backgroundImage.image = self.viewModel?.backgroundImage
        self.containerStackView.addArrangedSubview(self.descriptionLabel)
        self.descriptionLabel.text = self.viewModel?.description
        self.initView()
        self.setTapRecognizer()
        self.setUpTapAction()
    }
    
    private func initView() {
        self.addSubview(self.containerViewView)
        self.containerViewView.addSubview(self.backgroundImage)
        self.backgroundImage.addSubview(self.coloredView)
        self.coloredView.addSubview(self.containerStackView)
        self.coloredView.layer.insertSublayer(self.gradient, at: 0)
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setter
    func setValueLabelTo(_ text: String) {
        self.valueLabel.text = text
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.containerViewView.bounds
    }
    
    //MARK: - Private methods
    private func setUpTapAction() {
        self.tapped = { [weak self] in
            if let self = self,
                let a = self.superview?.superview  {
                DTCustomAlert.shared.showInfoAlert(oVview: a, with: self)
            }
        }
    }
    
    private func setShadowForMainView() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowOpacity = 5
    }
    
    private func setTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapSelector))
        self.addGestureRecognizer(tap)
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.containerViewView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerViewView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.containerViewView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.containerViewView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
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
            self.backgroundImage.topAnchor.constraint(equalTo: self.containerViewView.topAnchor),
            self.backgroundImage.leftAnchor.constraint(equalTo: self.containerViewView.leftAnchor),
            self.backgroundImage.rightAnchor.constraint(equalTo: self.containerViewView.rightAnchor),
            self.backgroundImage.bottomAnchor.constraint(equalTo: self.containerViewView.bottomAnchor)
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
    
    //MARK: - Actions
    @objc private func tapSelector() {
        self.tapped?()
    }
}

//MARK: - DTMainInfoViewPresenter
extension DTMainInfoView: DTMainInfoViewPresenter {
    
    func settingWasChanged() {
        self.valueLabel.text = self.viewModel?.value
        self.descriptionLabel.text = self.viewModel?.description
    }
    
    
    var type: InfoViewValueType? {
        return self._type
    }
    
    func updateInfo() {
        self.valueLabel.text = self.viewModel?.value
    }
}
