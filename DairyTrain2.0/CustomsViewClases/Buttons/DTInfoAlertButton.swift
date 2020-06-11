import UIKit


class DTInfoAlertButton: UIButton {
    
    //MARK: - GUI Properties
    lazy var animateView: UIView = {
        let view = UIView()
        return view
    }()
    
    //MARK: - Private properties
    private var isPressed: Bool = false
    
    //MARK: - Initialization
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setBehavor()
        self.setAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setAppearance() {
        self.backgroundColor = .clear
        self.tintColor = .white
        self.layer.cornerRadius = 10
    
    }

    
    private func setBehavor() {
        self.addTarget(self, action: #selector(self.behavor), for: [.touchUpInside, .touchDown])
    }
    
    private func pressed() {
        self.backgroundColor = .darkGray
        self.isPressed = true
    }
    
    private func unPressed() {
        self.backgroundColor = .clear
        self.isPressed = true
    }
    
    @objc func behavor() {
        self.isPressed ? self.unPressed() : self.pressed()
    }
    
    
}
