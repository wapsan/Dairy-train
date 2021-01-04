import UIKit

class DTSynhronizeCell: UITableViewCell {
    
    
    //MARK: - GUI Properties
    private lazy var titleLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.textColor = .white
        label.textAlignment = .left
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
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = DTColors.controllBorderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        self.backgroundColor = DTColors.controllUnselectedColor
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.lastSynhronizeDateLabel)
        self.contentView.addSubview(self.separatorLine)
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
                                                 constant: DTEdgeInsets.small.top),
            self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,
                                                  constant: DTEdgeInsets.small.left),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                    constant: DTEdgeInsets.small.bottom),
            self.titleLabel.rightAnchor.constraint(equalTo: self.lastSynhronizeDateLabel.leftAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,
                                                   multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            self.lastSynhronizeDateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                              constant: DTEdgeInsets.small.top),
            self.lastSynhronizeDateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,
                                                                constant: DTEdgeInsets.small.right),
            self.lastSynhronizeDateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                                 constant: DTEdgeInsets.small.bottom),
        ])
        
        NSLayoutConstraint.activate([
            self.separatorLine.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.separatorLine.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.separatorLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}