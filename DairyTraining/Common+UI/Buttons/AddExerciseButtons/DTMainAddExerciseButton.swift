import UIKit

final class DTMainAddExerciseButton: UIButton {
    
    //MARK: - Private properties
    private var isOpen: Bool = false
    
    //MARK: - Properties
    var openAction: ((_ isOpen: Bool) -> Void)?
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 3)
        self.layer.shadowOpacity = 0.3
        super.layoutSubviews()
    }
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DTColors.controllSelectedColor
        self.setImage(UIImage(named: "addTraining"), for: .normal)
        self.addTarget(self,
                       action: #selector(self.pressedButtonAction),
                       for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func close() {
        if isOpen {
            openAction?(isOpen)
            UIView.animate(withDuration: 0.25, animations: {
                self.imageView?.transform = CGAffineTransform(rotationAngle: .pi - 3.14)
            })
            isOpen = !isOpen
        }
    }
    
   private func tapAction() {
        openAction?(isOpen)
         switch isOpen {
         case false:
             UIView.animate(withDuration: 0.25, animations: {
                 self.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
             })
         case true:
             UIView.animate(withDuration: 0.25, animations: {
                 self.imageView?.transform = CGAffineTransform(rotationAngle: .pi - 3.14)
             })
         }
        isOpen = !isOpen
    }
    
    //MARK: - Actions
    @objc private func pressedButtonAction() {
        self.tapAction()
    }
}
