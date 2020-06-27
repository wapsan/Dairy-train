import UIKit

class DTTrainCell: UICollectionViewCell {
    
    //MARK: - Static cellID
    static let cellID = "TESTDTTrainCollectionCell"
    
    //MARK: - GUI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .viewFlipsideBckgoundColor
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = .init(width: 0, height: 5)
        view.layer.shadowOpacity = 5
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dateLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 20)
        label.text = "10 May 2020"
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
    
    //MARK: - Private methods
    private func initCell() {
        self.backgroundColor = .clear
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.imageContainerView)
        self.containerView.addSubview(self.dateLabel)
        for image in self.groupImages {
            self.containerView.addSubview(image)
        }
        self.imageContainerView.addSubview(self.horizontalLine)
        self.imageContainerView.addSubview(self.verticalLine)
        self.setUpConstraints()
    }
    
    private func hideIcons() {
        for icon in self.groupImages {
            icon.isHidden = true
        }
    }
    
    //MARK: - Setter
    func setBackgroundColorTo(_ color: UIColor) {
        self.containerView.backgroundColor = color
    }
    
    func setCellFor(_ train: TrainingManagedObject) {
        guard let formatedDate = train.formatedDate else { return }
        self.dateLabel.text = formatedDate
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
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            self.imageContainerView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor,
                                                            constant: -8),
            self.imageContainerView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor,
                                                           constant: -8),
            self.imageContainerView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                          constant: 8),
            self.imageContainerView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.imageContainerView.heightAnchor.constraint(equalTo: self.imageContainerView.widthAnchor,
                                                            multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 8),
            self.dateLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16),
            self.dateLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.imageContainerView.topAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            self.firstGroupImage.leftAnchor.constraint(equalTo: self.imageContainerView.leftAnchor,
                                                       constant: 0),
            self.firstGroupImage.topAnchor.constraint(equalTo: self.imageContainerView.topAnchor,
                                                      constant: 0),
            self.firstGroupImage.rightAnchor.constraint(equalTo: self.secondGroupImage.leftAnchor,
                                                        constant: -8),
            self.firstGroupImage.bottomAnchor.constraint(equalTo: self.thirdGroupImage.topAnchor,
                                                         constant: -8),
            self.firstGroupImage.heightAnchor.constraint(equalTo: self.firstGroupImage.widthAnchor, multiplier: 1),
            self.firstGroupImage.heightAnchor.constraint(equalTo: self.secondGroupImage.heightAnchor, multiplier: 1),
            self.firstGroupImage.heightAnchor.constraint(equalTo: self.thirdGroupImage.heightAnchor, multiplier: 1),
            self.firstGroupImage.heightAnchor.constraint(equalTo: self.fourthGroupImage.heightAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.secondGroupImage.topAnchor.constraint(equalTo: self.imageContainerView.topAnchor, constant: 0),
            self.secondGroupImage.rightAnchor.constraint(equalTo: self.imageContainerView.rightAnchor, constant: 0),
            self.secondGroupImage.bottomAnchor.constraint(equalTo: self.fourthGroupImage.topAnchor, constant: -8),
            self.secondGroupImage.heightAnchor.constraint(equalTo: self.secondGroupImage.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.thirdGroupImage.leftAnchor.constraint(equalTo: self.imageContainerView.leftAnchor, constant: 0),
            self.thirdGroupImage.rightAnchor.constraint(equalTo: self.fourthGroupImage.leftAnchor, constant: -8),
            self.thirdGroupImage.bottomAnchor.constraint(equalTo: self.imageContainerView.bottomAnchor, constant: 0),
            self.thirdGroupImage.heightAnchor.constraint(equalTo: self.thirdGroupImage.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.fourthGroupImage.rightAnchor.constraint(equalTo: self.imageContainerView.rightAnchor, constant: 0),
            self.fourthGroupImage.bottomAnchor.constraint(equalTo: self.imageContainerView.bottomAnchor, constant: 0),
            self.fourthGroupImage.heightAnchor.constraint(equalTo: self.fourthGroupImage.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.horizontalLine.heightAnchor.constraint(equalToConstant: 1),
            self.horizontalLine.widthAnchor.constraint(equalTo: self.imageContainerView.widthAnchor, multiplier: 1),
            self.horizontalLine.centerYAnchor.constraint(equalTo: self.imageContainerView.centerYAnchor),
            self.horizontalLine.centerXAnchor.constraint(equalTo: self.imageContainerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.verticalLine.widthAnchor.constraint(equalToConstant: 1),
            self.verticalLine.heightAnchor.constraint(equalTo: self.imageContainerView.widthAnchor, multiplier: 1),
            self.verticalLine.centerYAnchor.constraint(equalTo: self.imageContainerView.centerYAnchor),
            self.verticalLine.centerXAnchor.constraint(equalTo: self.imageContainerView.centerXAnchor)
        ])
    }
}
