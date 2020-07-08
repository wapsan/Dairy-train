import UIKit

class DTSynhronizeCell: UITableViewCell {
    
    //MARK: - Static cellID
    static let cellID = "DTSynhronizeCell"
    
    //MARK: - GUI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.text = LocalizedString.synhronization
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lastSynhronizeDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DTSynhronizeCell.cellID)
        self.initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCell() {
        self.selectionStyle = .none
        self.backgroundColor = .viewFlipsideBckgoundColor
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.lastSynhronizeDateLabel)
        self.setUpConstraints()
    }
    
    //MARK: - Setter
    func setUpdateDateTo(_ date: String) {
        self.lastSynhronizeDateLabel.text = date
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                 constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,
                                                  constant: 8),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                    constant: -8),
            self.titleLabel.rightAnchor.constraint(equalTo: self.lastSynhronizeDateLabel.leftAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.lastSynhronizeDateLabel.widthAnchor,
                                                   multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.lastSynhronizeDateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                              constant: 8),
            self.lastSynhronizeDateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,
                                                                constant: -8),
            self.lastSynhronizeDateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                                 constant: -8)
        ])
    }
}
