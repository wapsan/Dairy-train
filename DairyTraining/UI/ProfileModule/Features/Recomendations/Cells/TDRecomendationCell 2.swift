import UIKit

class TDRecomendationCell: UITableViewCell {
    
    //MARK: - Static cellID
    static let cellID = "DTRecomendationCell"
    
    //MARK: - GUI Properties
    private lazy var caloriesLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var proteinsLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var carbohydratesLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var fatsLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
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
    
    private func initCell() {
        self.backgroundColor = .viewFlipsideBckgoundColor
        self.selectionStyle = .none
        self.addSubview(self.labelsStackView)
        self.setConstraints()
    }

    //MARK: - Seter
    func setCell(for recomendationInfo: RecomendationInfo) {
        self.caloriesLabel.text = recomendationInfo.caloriesRecomendation
        self.proteinsLabel.text = recomendationInfo.proteinRecomendation
        self.carbohydratesLabel.text = recomendationInfo.carbohydratesRcomendation
        self.fatsLabel.text = recomendationInfo.fatRecomandation
    }

    //MARK: - Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.labelsStackView.topAnchor.constraint(equalTo: self.topAnchor,
                                                      constant: DTEdgeInsets.small.top),
            self.labelsStackView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                       constant: DTEdgeInsets.small.left),
            self.labelsStackView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                        constant: DTEdgeInsets.small.right),
            self.labelsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                         constant: DTEdgeInsets.small.bottom),
        ])
    }
}
