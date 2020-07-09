import UIKit

class DTTrainCell: UICollectionViewCell {
    
    //MARK: - Static cellID
    static let cellID = "TESTDTTrainCollectionCell"
    
    //MARK: - CALayers
    private lazy var defaultGradient: CAGradientLayer = {
        let gradient = DTGradientLayerMaker.shared.makeDefaultGradient()
        return gradient
    }()
    
    private lazy var selectedGradient: CAGradientLayer = {
        let gradient = DTGradientLayerMaker.shared.makeSelectedGradient()
        return gradient
    }()
    
    //MARK: - GUI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dateLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var firstGroupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.chestImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var secondGroupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.chestImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var thirdGroupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.chestImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var fourthGroupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.chestImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var groupImages = [self.firstGroupImage,
                                    self.secondGroupImage,
                                    self.thirdGroupImage,
                                    self.fourthGroupImage]
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCell()
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCell() {
        self.backgroundColor = .clear
        self.addSubview(self.containerView)
        self.addSubview(self.imageContainerView)
        self.addSubview(self.dateLabel)
        for image in self.groupImages {
            self.addSubview(image)
        }
        self.addSubview(self.horizontalLine)
        self.addSubview(self.verticalLine)
        self.setUpConstraints()
        self.setGradientsLayer()
    }
    
    //MARK: - Private methods
    private func hideIcons() {
        for icon in self.groupImages {
            icon.isHidden = true
        }
    }
    
    private func setGradientsLayer() {
        self.containerView.layer.addSublayer(self.defaultGradient)
        self.containerView.layer.addSublayer(self.selectedGradient)
        self.defaultGradient.bringToFront()
    }
    
    //MARK: - Setter
    func setBackgroundColorTo(_ color: UIColor) {
        self.containerView.backgroundColor = color
    }
    
    func setCellFor(_ train: TrainingManagedObject) {
        guard let formatedDate = train.formatedDate else { return }
        self.dateLabel.text = formatedDate
    }
    
    func setSelectedBackground() {
        self.selectedGradient.bringToFront()
    }
    
    func setDeselectedBackground() {
        self.defaultGradient.bringToFront()
    }
    
    func setGroupIcons(by groups: [MuscleGroup.Group]) {
        self.hideIcons()
        if self.groupImages.count >= groups.count {
            for (index, group) in groups.enumerated() {
                self.groupImages[index].image = group.image
                self.groupImages[index].isHidden = false
            }
        } else {
            for (index, icon) in self.groupImages.enumerated() {
                icon.image = groups[index].image
                icon.isHidden = false
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.defaultGradient.frame = self.containerView.bounds
        self.selectedGradient.frame = self.containerView.bounds
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
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
            self.imageContainerView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor,
                                                            constant: DTEdgeInsets.small.bottom),
            self.imageContainerView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor,
                                                           constant: DTEdgeInsets.small.right),
            self.imageContainerView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                          constant: DTEdgeInsets.small.left),
            self.imageContainerView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.imageContainerView.heightAnchor.constraint(equalTo: self.imageContainerView.widthAnchor,
                                                            multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                constant: DTEdgeInsets.small.top),
            self.dateLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                 constant: DTEdgeInsets.medium.left),
            self.dateLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor,
                                                  constant: DTEdgeInsets.small.right),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.imageContainerView.topAnchor,
                                                   constant: DTEdgeInsets.small.bottom)
        ])
        
        NSLayoutConstraint.activate([
            self.firstGroupImage.leftAnchor.constraint(equalTo: self.imageContainerView.leftAnchor),
            self.firstGroupImage.topAnchor.constraint(equalTo: self.imageContainerView.topAnchor),
            self.firstGroupImage.rightAnchor.constraint(equalTo: self.secondGroupImage.leftAnchor,
                                                        constant: DTEdgeInsets.small.right),
            self.firstGroupImage.bottomAnchor.constraint(equalTo: self.thirdGroupImage.topAnchor,
                                                         constant: DTEdgeInsets.small.bottom),
            self.firstGroupImage.heightAnchor.constraint(equalTo: self.firstGroupImage.widthAnchor),
            self.firstGroupImage.heightAnchor.constraint(equalTo: self.secondGroupImage.heightAnchor),
            self.firstGroupImage.heightAnchor.constraint(equalTo: self.thirdGroupImage.heightAnchor),
            self.firstGroupImage.heightAnchor.constraint(equalTo: self.fourthGroupImage.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.secondGroupImage.topAnchor.constraint(equalTo: self.imageContainerView.topAnchor),
            self.secondGroupImage.rightAnchor.constraint(equalTo: self.imageContainerView.rightAnchor),
            self.secondGroupImage.bottomAnchor.constraint(equalTo: self.fourthGroupImage.topAnchor,
                                                          constant: DTEdgeInsets.small.bottom),
            self.secondGroupImage.heightAnchor.constraint(equalTo: self.secondGroupImage.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.thirdGroupImage.leftAnchor.constraint(equalTo: self.imageContainerView.leftAnchor),
            self.thirdGroupImage.rightAnchor.constraint(equalTo: self.fourthGroupImage.leftAnchor,
                                                        constant: DTEdgeInsets.small.right),
            self.thirdGroupImage.bottomAnchor.constraint(equalTo: self.imageContainerView.bottomAnchor),
            self.thirdGroupImage.heightAnchor.constraint(equalTo: self.thirdGroupImage.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.fourthGroupImage.rightAnchor.constraint(equalTo: self.imageContainerView.rightAnchor),
            self.fourthGroupImage.bottomAnchor.constraint(equalTo: self.imageContainerView.bottomAnchor),
            self.fourthGroupImage.heightAnchor.constraint(equalTo: self.fourthGroupImage.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.horizontalLine.heightAnchor.constraint(equalToConstant: 1),
            self.horizontalLine.widthAnchor.constraint(equalTo: self.imageContainerView.widthAnchor),
            self.horizontalLine.centerYAnchor.constraint(equalTo: self.imageContainerView.centerYAnchor),
            self.horizontalLine.centerXAnchor.constraint(equalTo: self.imageContainerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.verticalLine.widthAnchor.constraint(equalToConstant: 1),
            self.verticalLine.heightAnchor.constraint(equalTo: self.imageContainerView.widthAnchor),
            self.verticalLine.centerYAnchor.constraint(equalTo: self.imageContainerView.centerYAnchor),
            self.verticalLine.centerXAnchor.constraint(equalTo: self.imageContainerView.centerXAnchor)
        ])
    }
}
