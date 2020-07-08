import UIKit

class DTInfoAlertButton: UIButton {
    
    //MARK: - GUI Properties
    private lazy var customTittle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Private properties
    private lazy var isPressed: Bool = false
    
    //MARK: - Initialization
    init(title: String) {
        super.init(frame: .zero)        
        self.addSubview(self.customTittle)
        self.customTittle.text = title
        self.activateConstraints()
        self.setBehavor()
        self.setAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Constraints
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            self.customTittle.topAnchor.constraint(equalTo: self.topAnchor),
            self.customTittle.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.customTittle.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.customTittle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
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
