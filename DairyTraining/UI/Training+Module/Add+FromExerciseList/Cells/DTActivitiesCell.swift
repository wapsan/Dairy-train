import UIKit

final class DTActivitiesCell: UITableViewCell {
    
    //MARK: - Static cellID
    static let cellID: String = "DTActivitiesCell"
    
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
    
    private lazy var coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = DTColors.backgroundColor.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        self.containerView.backgroundColor = DTColors.controllUnselectedColor
        self.setUpConstraints()
    }
    
    //MARK: - Setters
    func renderCellFor<T: Groupable>(_ groupable: T) {
        self.exerciceNameLabel.text = NSLocalizedString(groupable.name, comment: "")
        self.muscleGroupImage.image = groupable.image
    }
    
    func setUnselectedBackgroundColor() {
        self.containerView.backgroundColor = DTColors.controllUnselectedColor
    }
    
    func setSelectedBackgroundColor() {
        self.containerView.backgroundColor = DTColors.controllSelectedColor
    }
    
    //MARK: - Publick methods
    override func layoutSubviews() {
        self.containerView.layer.cornerRadius = self.containerView.bounds.height / 4
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = DTColors.controllBorderColor.cgColor
        super.layoutSubviews()
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
