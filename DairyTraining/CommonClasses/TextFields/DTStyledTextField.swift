import UIKit

@IBDesignable
class DTStyledTextField: UITextField {

    //MARK: - Private methods
    func initTextField() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    }
    
    //MARK: - Publick methods
    override func prepareForInterfaceBuilder() {
        self.initTextField()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.initTextField()
    }
}
