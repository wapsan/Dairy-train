import UIKit

class DTSystemButton: UIButton {
    
    //MARK: - Properties
    var isPressed: Bool = false
    
    var pressedBackgroundColor: UIColor {
        UIColor.red.withAlphaComponent(0.5)
    }
    
    var unpressedBackgroundColor: UIColor {
        UIColor.red
    }
    
    //MARK: - Initialization
    init(tittle: String) {
        super.init(frame: .zero)
        self.setTitle(tittle, for: .normal)
        self.setAppearance()
        self.setBehavors()
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.minimumScaleFactor = 0.1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setLayotLayer()
    }
    
    //MARK: - Private methods
    private func setAppearance() {
        self.backgroundColor = .red
        self.titleLabel?.textColor = .white
        self.titleLabel?.font = .systemFont(ofSize: 20)
    }
    
    private func setBehavors() {
        self.addTarget(self, action: #selector(self.behavor), for: [.touchUpInside,
                                                                    .touchUpOutside,
                                                                    .touchDown,
                                                                    .touchCancel])
    }
    
    private func setLayotLayer() {
        self.layer.cornerRadius = self.bounds.size.height / 3.57
    }
    
    //MARK: - Public methods
    func unpressed() {
        self.backgroundColor = self.unpressedBackgroundColor
        self.isUserInteractionEnabled = true
        self.isPressed = false
    }
    
    func pressed() {
        self.backgroundColor = self.pressedBackgroundColor
        self.isUserInteractionEnabled = false
        self.isPressed = true
    }
    
    //MARK: - Actions
    @objc private func behavor() {
        self.isPressed ? self.unpressed() : self.pressed()
    }
}
