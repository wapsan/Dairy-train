import UIKit

class AddExerciseSupportButton: UIView {
    
    //MARK: - Types
    enum SupprotButtonType {
        case pattern
        case exercoseList
        case training
    }
    
    //MARK: - @IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    
    //MARK: - Properties
    private var action: (() -> Void)?
    var supportButtonType: SupprotButtonType? {
        didSet {
            guard let buttonType = supportButtonType else { return }
            setupFor(buttonType: buttonType)
        }
    }
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    class func view() -> AddExerciseSupportButton? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? AddExerciseSupportButton
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.layer.cornerRadius = self.bounds.height / 2
        actionButton.layer.shadowColor = UIColor.white.cgColor
        actionButton.layer.shadowOffset = .init(width: 0, height: 3)
    }
    
    //MARK: - Setup
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        actionButton.backgroundColor = DTColors.controllSelectedColor
        titleLabel.alpha = 0
    }
    
    private func setupFor(buttonType: SupprotButtonType) {
        actionButton.tintColor = .white
        switch buttonType {
        case .pattern:
            action = {
                MainCoordinator.shared.coordinate(to: TrainingModuleCoordinator.Target.trainingPaternsList)
            }
            titleLabel.text = "Patern list"
            actionButton.setImage(UIImage(named: "paternList")?.withTintColor(.white), for: .normal)
        case .exercoseList:
            action = {
                MainCoordinator.shared.coordinate(to: MuscleGroupsCoordinator.Target.muscularGrops(patern: .training))
            }
            titleLabel.text = "Exercise list"
            
            actionButton.setImage(UIImage(named: "activities2"), for: .normal)
        case .training:
            action = {
                
            }
            titleLabel.text = "Ready training for you"
            actionButton.setImage(UIImage(named: "trash")?.withTintColor(.white), for: .normal)
        }
        actionButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func open() {
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 3)
        guard let buttonType = self.supportButtonType else { return }
        switch buttonType {
        case .pattern:
            UIView.animate(withDuration: 0.25, animations: {
              self.layer.shadowOpacity = 0.3
                self.titleLabel.alpha = 1
                self.transform = CGAffineTransform(translationX:  0, y: -self.bounds.height - 16)
            })
        case .exercoseList:
            UIView.animate(withDuration: 0.25, animations: {
                self.layer.shadowOpacity = 0.3
                self.titleLabel.alpha = 1
                self.transform = CGAffineTransform(translationX: 0, y: (-self.bounds.height * 2) - 32)
            })
        case .training:
            UIView.animate(withDuration: 0.25, animations: {
                self.layer.shadowOpacity = 0.3
                self.titleLabel.alpha = 1
                self.transform = CGAffineTransform(translationX: 0, y: (-self.bounds.height * 3) - 48)
            })
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.25, animations: {
            self.titleLabel.alpha = 0
            self.layer.shadowOpacity = 0
            self.transform = .identity
        })
    }
    
    //MARK: - Actions
    @IBAction func buttonAction(_ sender: UIButton) {
        action?()
    }
}
