import UIKit

class DTActivitiesCell: UITableViewCell {
    
    //MARK: - Static cellID
    static let cellID: String = "DTActivitiesCell"
    
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
    
    private lazy var exerciceNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var muscleGroupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DTActivitiesCell.cellID)
        self.initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCell() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.addSubview(self.containerView)
        self.addSubview(self.muscleGroupImage)
        self.addSubview(self.exerciceNameLabel)
        self.setUpConstraints()
        self.setUpGradientsLayers()
    }
    
    //MARK: - Setters
    func setCellFor(_ muscleGroup: MuscleGroup.Group) {
        self.exerciceNameLabel.text =  NSLocalizedString(muscleGroup.rawValue, comment: "")
        self.muscleGroupImage.image = muscleGroup.image
    }
    
    func setCellFor(_ muscleSubroup: MuscleSubgroup.Subgroup) {
        self.exerciceNameLabel.text = NSLocalizedString(muscleSubroup.rawValue, comment: "")
        self.muscleGroupImage.image = muscleSubroup.image
    }
    
    func setCellFor(_ exercice: Exercise) {
        self.exerciceNameLabel.text = exercice.name
        self.muscleGroupImage.image = exercice.muscleSubGroupImage
    }
    
    func setUnselectedBackgroundColor() {
        self.defaultGradient.bringToFront()
    }
    
    func setSelectedBackgroundColor() {
        self.selectedGradient.bringToFront()
    }
    
    //MARK: - Publick methods
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectedGradient.frame = self.containerView.bounds
        self.defaultGradient.frame = self.containerView.bounds
    }
    
    //MARK: - Private methods
    private func setUpGradientsLayers() {
        self.containerView.layer.addSublayer(self.defaultGradient)
        self.containerView.layer.addSublayer(self.selectedGradient)
        self.defaultGradient.bringToFront()
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
            self.exerciceNameLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                        constant: DTEdgeInsets.small.top),
            self.exerciceNameLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor,
                                                          constant: DTEdgeInsets.small.right),
            self.exerciceNameLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor,
                                                           constant: DTEdgeInsets.small.bottom),
            self.exerciceNameLabel.leftAnchor.constraint(equalTo: self.muscleGroupImage.rightAnchor,
                                                         constant: DTEdgeInsets.small.left),
            self.exerciceNameLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.muscleGroupImage.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                       constant: DTEdgeInsets.small.top),
            self.muscleGroupImage.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor,
                                                          constant: DTEdgeInsets.small.bottom),
            self.muscleGroupImage.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                        constant: DTEdgeInsets.small.left),
            self.muscleGroupImage.widthAnchor.constraint(equalTo: self.muscleGroupImage.heightAnchor,
                                                         multiplier: 1),
            self.muscleGroupImage.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor)
        ])
    }
}
