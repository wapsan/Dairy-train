import UIKit

class DTTextField: UITextField {
    
  
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.font = .systemFont(ofSize: 20)
        self.textAlignment = .center
        self.textColor = .white
    }
    
}
