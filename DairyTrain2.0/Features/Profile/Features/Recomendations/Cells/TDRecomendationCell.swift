import UIKit

class TDRecomendationCell: UITableViewCell {
    
    //MARK: - Static cellID
    static let cellID = "TESTTDRecomendationCell"
    
    //MARK: - GUI Properties
    lazy var caloriesLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var proteinsLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var carbohydratesLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var fatsLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self.caloriesLabel)
        stackView.addArrangedSubview(self.proteinsLabel)
        stackView.addArrangedSubview(self.carbohydratesLabel)
        stackView.addArrangedSubview(self.fatsLabel)
        return stackView
    }()
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TDRecomendationCell.cellID)
        self.initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func initCell() {
        self.addSubview(self.labelsStackView)
        self.setConstraints()
        self.setCell()
    }
    
    private func setCell() {
        self.backgroundColor = .viewFlipsideBckgoundColor
        self.selectionStyle = .none
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.labelsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.labelsStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.labelsStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.labelsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
        ])
    }
    
}
