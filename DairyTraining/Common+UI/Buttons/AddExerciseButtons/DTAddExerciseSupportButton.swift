import UIKit

final class DTAddExerciseSupportButton: UIButton {
    
    //MARK: - Support type enumeration
    enum SupprotButtonType {
        case pattern
        case exercoseList
    }
    
    //MARK: - Properties
    var action: (() -> Void)?
    var supportType: SupprotButtonType
    
    //MARK: - Initialization
    init(type: SupprotButtonType) {
        self.supportType = type
        super.init(frame: .zero)
        self.backgroundColor = DTColors.controllSelectedColor
        self.addTarget(self,
                       action: #selector(self.selfAction),
                       for: .touchUpInside)
        switch self.supportType {
        case .pattern:
            self.setImage(UIImage(named: "paternList")?.withTintColor(.white), for: .normal)
        case .exercoseList:
            self.setImage(UIImage(named: "activities2")?.withTintColor(.white), for: .normal)
        }
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 3)
        super.layoutSubviews()
    }
    
    //MARK: - Public methods
    func open() {
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 3)
        switch self.supportType {
        case .pattern:
            UIView.animate(withDuration: 0.25, animations: {
              self.layer.shadowOpacity = 0.3
                self.transform = CGAffineTransform(translationX: -self.bounds.height - 16 , y: 0)
            })
        case .exercoseList:
            UIView.animate(withDuration: 0.25, animations: {
                self.layer.shadowOpacity = 0.3
                self.transform = CGAffineTransform(translationX: 0, y: -self.bounds.height - 16)
            })
        }
    }
    
    func close() {
        switch self.supportType {
        case .pattern:
            UIView.animate(withDuration: 0.25, animations: {
                self.layer.shadowOpacity = 0
                self.transform = .identity
            })
        case .exercoseList:
            UIView.animate(withDuration: 0.25, animations: {
                self.layer.shadowOpacity = 0
                self.transform = .identity
            })
        }
    }

    //MARK: - Actions
    @objc private func selfAction() {
        action?()
    }
}
