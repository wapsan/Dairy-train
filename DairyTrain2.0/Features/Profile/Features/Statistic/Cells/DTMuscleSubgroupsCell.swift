import UIKit

class DTMuscleSubgroupsCell: UICollectionViewCell {
    
    //MARK: - Static cellID
    static let cellID = "DTMuscleSubgroupsCell"
    
    //MARK: - GUI Properties
    private lazy var muscleSubgropImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        self.contentView.addSubview(self.muscleSubgropImageView)
        self.setUpConstraints()
    }
    
    //MARK: - Public methods
    func setCellImage(to image: UIImage?) {
        self.muscleSubgropImageView.image = image
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.muscleSubgropImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.muscleSubgropImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.muscleSubgropImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.muscleSubgropImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
}