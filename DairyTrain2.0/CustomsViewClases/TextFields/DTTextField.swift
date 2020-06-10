import UIKit

class DTTextField: UITextField {
    
    //MARK: - GUI Properties
    lazy var whiteLineUnderTextField: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    init(placeholder: String) {
        super.init(frame: .zero)
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Private methods
    private func initView() {
        self.font = .systemFont(ofSize: 20)
        self.textAlignment = .center
        self.textColor = .white
        self.addSubview(self.whiteLineUnderTextField)
        self.setUpConstraints()
    }
    
    
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.whiteLineUnderTextField.heightAnchor.constraint(equalToConstant: 1),
            self.whiteLineUnderTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.whiteLineUnderTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.whiteLineUnderTextField.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
