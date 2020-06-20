import UIKit

class DTActivitiesCell: UITableViewCell {
    
    //MARK: - Static cellID
    static let cellID: String = "DTActivitiesCell"
    
    //MARK: - GUI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .viewFlipsideBckgoundColor
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = .init(width: 0, height: 5)
        view.layer.shadowOpacity = 5
        view.layer.cornerRadius = 20
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
    }
    
    //MARK: - Setter
    func setCellFor(_ muscleGroup: MuscleGroup.Group) {
        self.exerciceNameLabel.text = muscleGroup.rawValue
        self.muscleGroupImage.image = muscleGroup.image
    }
    
    func setCellFor(_ muscleSubroup: MuscleSubgroup.Subgroup) {
        self.exerciceNameLabel.text = muscleSubroup.rawValue
        self.muscleGroupImage.image = muscleSubroup.image
    }
    
    func setCellFor(_ exercice: Exercise) {
        self.exerciceNameLabel.text = exercice.name
        self.muscleGroupImage.image = exercice.muscleSubGroupImage
    }
    
    func setBackroundColorTo(_ color: UIColor) {
        self.containerView.backgroundColor = color
    }
    //MARK: - Private Methods
    private func setLayout() {
        self.containerView.layer.cornerRadius = self.containerView.bounds.height / 2
    }
   
    //MARK: - Publick methods
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setLayout()
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
       
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.containerView.heightAnchor.constraint(lessThanOrEqualTo: self.containerView.widthAnchor, multiplier: 1/4)
        ])
        
        NSLayoutConstraint.activate([
            self.exerciceNameLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 8),
            self.exerciceNameLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -8),
            self.exerciceNameLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -8),
            self.exerciceNameLabel.leftAnchor.constraint(equalTo: self.muscleGroupImage.rightAnchor, constant: 8),
            self.exerciceNameLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.muscleGroupImage.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 8),
            self.muscleGroupImage.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -8),
            self.muscleGroupImage.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 8),
            self.muscleGroupImage.widthAnchor.constraint(equalTo: self.muscleGroupImage.heightAnchor, multiplier: 1),
            self.muscleGroupImage.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
        ])
    }
}


