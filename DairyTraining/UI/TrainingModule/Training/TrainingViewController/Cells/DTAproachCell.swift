import UIKit

class DTAproachCell: UICollectionViewCell {
    
    //MARK: - Private properties
    private var aproach: AproachManagedObject?
    var tapAction: ((_ weight: String, _ reps: String) -> Void)?
    
    //MARK: - GUI Properties
    private lazy var aproachNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var weightLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var repsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped))
        return tap
    }()
    
    //MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setGuiElements()
        self.addGestureRecognizer(self.tapGesture)
    }
    
    //MARK: - Setter
    func setUpFor(_ aproach: AproachManagedObject) {
        self.aproach = aproach
        self.weightLabel.text = aproach.weightDisplayvalue
        self.repsLabel.text = aproach.repsDisplayValue
        self.aproachNumberLabel.text = "№ \(aproach.number)"
    }
}

//MARK: - Private methods
private extension DTAproachCell {
    
    func setGuiElements() {
        self.addSubview(self.weightLabel)
        self.addSubview(self.repsLabel)
        self.addSubview(self.aproachNumberLabel)
        self.setUpConstraints()
    }
    
    func setUpConstraints() {
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
            self.weightLabel.heightAnchor.constraint(equalTo: self.aproachNumberLabel.heightAnchor,
                                                     multiplier: 1.3)
        ])
        
        NSLayoutConstraint.activate([
            self.repsLabel.topAnchor.constraint(equalTo: self.weightLabel.bottomAnchor),
            self.repsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.repsLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.repsLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.repsLabel.heightAnchor.constraint(equalTo: self.aproachNumberLabel.heightAnchor,
                                                   multiplier: 1.3)
        ])
    }
    
    //MARK: - Actions
    @objc  func cellTapped() {
        guard let weight = self.weightLabel.text,
            let reps = self.repsLabel.text else { return }
        self.tapAction?(weight, reps)
    }
}
