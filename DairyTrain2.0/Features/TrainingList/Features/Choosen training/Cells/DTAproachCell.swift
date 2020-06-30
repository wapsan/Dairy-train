import UIKit

class DTAproachCell: UICollectionViewCell {
    
    //MARK: - Static properties
    static let cellID = "TestAproachCell"
    private var aproach: AproachManagedObject?
    
    //MARK: - GUI Properties
    private lazy var aproachNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "№1"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var weightLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.text = "80 kg."
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var repsLabel: UILabel = {
        let label = UILabel()
        label.text = "12 reps."
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setGuiElements()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setter
    func setUpFor(_ aproach: AproachManagedObject) {
        self.aproach = aproach
        self.weightLabel.text = aproach.weightDisplayvalue
        self.repsLabel.text = aproach.repsDisplayValue
        self.aproachNumberLabel.text = "№ \(aproach.number)"
    }
    
    //MARK: - Actions
  
 
    //MARK: - Private methods
    private func setGuiElements() {
        self.addSubview(self.weightLabel)
        self.addSubview(self.repsLabel)
        self.addSubview(self.aproachNumberLabel)
        self.setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.aproachNumberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.aproachNumberLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.aproachNumberLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.aproachNumberLabel.bottomAnchor.constraint(equalTo: self.weightLabel.topAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            self.weightLabel.bottomAnchor.constraint(equalTo: self.repsLabel.topAnchor),
            self.weightLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.weightLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.weightLabel.heightAnchor.constraint(equalTo: self.aproachNumberLabel.heightAnchor, multiplier: 1.3)
        ])
        
        NSLayoutConstraint.activate([
            self.repsLabel.topAnchor.constraint(equalTo: self.weightLabel.bottomAnchor),
            self.repsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.repsLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.repsLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.repsLabel.heightAnchor.constraint(equalTo: self.aproachNumberLabel.heightAnchor, multiplier: 1.3)
        ])
    }
}
