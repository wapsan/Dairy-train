import UIKit

@IBDesignable
class DTStyledTextField: UITextField {
    
    //MARK: - Properties @IBInspectable
    @IBInspectable var cornerRdius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRdius
        }
    }
    
    //MARK: - Private methods
    func setUp() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    }
    
    //MARK: - Publick methods
    override func prepareForInterfaceBuilder() {
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setUp()
    }
    
}
