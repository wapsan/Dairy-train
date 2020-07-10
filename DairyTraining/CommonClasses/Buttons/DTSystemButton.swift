import UIKit

class DTSystemButton: UIButton {
    
    //MARK: - Properties
    var isPressed: Bool = false
    
    //MARK: - Initialization
    init(tittle: String) {
        super.init(frame: .zero)
        self.setTitle(tittle, for: .normal)
        self.setAppearance()
        self.setBehavors()
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
        self.titleLabel?.font = .systemFont(ofSize: 25)
        self.setDefaultLayer()
    }
    
    private func setDefaultLayer() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowOpacity = 5
    }
    
    private func setBehavors() {
        self.addTarget(self, action: #selector(self.behavor), for: [.touchUpInside,
                                                                    .touchUpOutside,
                                                                    .touchDown,
                                                                    .touchCancel])
    }
    
    private func setLayotLayer() {
        self.layer.cornerRadius = self.bounds.size.height / 2
    }
    
    //MARK: - Public methods
    func unpressed() {
        self.frame.origin.y = self.frame.origin.y - 5
        self.layer.shadowOpacity = 5
        self.isUserInteractionEnabled = true
        self.isPressed = false
    }
    
    func pressed() {
        self.frame.origin.y = self.frame.origin.y + 5
        self.layer.shadowOpacity = 0
        self.isUserInteractionEnabled = false
        self.isPressed = true
    }
    
    //MARK: - Actions
    @objc private func behavor() {
        self.isPressed ? self.unpressed() : self.pressed()
    }
}
