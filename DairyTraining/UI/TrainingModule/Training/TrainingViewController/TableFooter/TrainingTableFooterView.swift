import UIKit

final class TrainingTableFooterView: UIView {
    
    // MARK: - @IBOutlets
    @IBOutlet private var containerView: UIView!
    
    // MARK: - Properties
    var onAction: (() -> Void)?
    var isActive: Bool = true {
        didSet {
            isActive ? setActiveBehavor() : setInactiveBehavor()
        }
    }
    
    // MARK: - Initialization
    static func view() -> TrainingTableFooterView? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? TrainingTableFooterView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor  = UIColor.white.cgColor
        containerView.layer.borderWidth = 1
    }
    
    private func setInactiveBehavor() {
        containerView.backgroundColor = DTColors.controllSelectedColor.withAlphaComponent(0.5)
        containerView.isUserInteractionEnabled = false
    }
    
    private func setActiveBehavor() {
        containerView.backgroundColor = DTColors.controllSelectedColor
        containerView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: Any) {
        onAction?()
    }
}
