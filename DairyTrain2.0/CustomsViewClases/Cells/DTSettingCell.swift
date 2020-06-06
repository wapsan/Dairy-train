import UIKit

class DTSettingCell: UITableViewCell {
   
    //MARK: - Static cellID
    static let cellID = "TESTDTSettignCell"
    
    //MARK: - GUI Properties
    lazy var markImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.rightArrow
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var mainSettingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var currentSettingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(self.currentSettingLabel)
        stackView.addArrangedSubview(self.markImage)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DTSettingCell.cellID)
        self.initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setCell() {
        self.backgroundColor = .viewFlipsideBckgoundColor
    }
    
    private func initCell() {
        self.setCell()
        self.addSubview(self.mainSettingLabel)
        self.addSubview(self.stackView)
        self.setUpConstraints()
    }
   
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.mainSettingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.mainSettingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.mainSettingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.mainSettingLabel.rightAnchor.constraint(greaterThanOrEqualTo: self.stackView.leftAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            self.markImage.heightAnchor.constraint(equalTo: self.markImage.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
    }
    
}
