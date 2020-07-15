import UIKit

class DTSettingCell: UITableViewCell {
    
    //MARK: - Static cellID
    static let cellID = "TESTDTSettignCell"
    
    //MARK: - GUI Properties
    private lazy var markImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.rightArrow
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private lazy var mainSettingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentSettingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
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
    
    private func initCell() {
        self.backgroundColor = .viewFlipsideBckgoundColor
        self.addSubview(self.mainSettingLabel)
        self.addSubview(self.stackView)
        self.setUpConstraints()
    }
    
    //MARK: - Setter
    func setSetingSectionCell(for setting: SettingModel) {
        self.mainSettingLabel.text = setting.title
        guard let currentValue = setting.currentValue else { return }
        self.currentSettingLabel.text = NSLocalizedString(currentValue, comment: "")
    }
    
    func setCurrentSettingCell(for settings: SettingModel, and index: Int) {
        self.mainSettingLabel.text = NSLocalizedString(settings.possibleSetting[index], comment: "")
        self.currentSettingLabel.text = nil
        self.selectionStyle = .none
    }
    
    func setCheked() {
        self.markImage.image = UIImage.checkMark
        self.isUserInteractionEnabled = false
    }
    
    func setUncheked() {
        self.markImage.image = nil
        self.isUserInteractionEnabled = true
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.mainSettingLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                       constant: DTEdgeInsets.small.top),
            self.mainSettingLabel.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                        constant: DTEdgeInsets.small.left),
            self.mainSettingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                          constant: DTEdgeInsets.small.bottom),
            self.mainSettingLabel.rightAnchor.constraint(greaterThanOrEqualTo: self.stackView.leftAnchor,
                                                         constant: DTEdgeInsets.small.right)
        ])
        
        NSLayoutConstraint.activate([
            self.markImage.heightAnchor.constraint(equalTo: self.markImage.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: DTEdgeInsets.small.top),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                  constant: DTEdgeInsets.small.right),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                   constant: DTEdgeInsets.small.bottom),
        ])
    }
}
