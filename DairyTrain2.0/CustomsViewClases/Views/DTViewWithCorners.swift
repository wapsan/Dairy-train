import UIKit

@IBDesignable
class DTViewWithCorners: UIView {
    
    //MARK: - Public properties
    @IBInspectable
    var isRound: Bool = false {
        didSet {
            self.layer.cornerRadius = self.isRound ? self.bounds.height / 2 : 0
        }
    }
    
    @IBInspectable
    var standartdCornerRadius: Bool = false {
        didSet {
            self.layer.cornerRadius = self.standartdCornerRadius ? self.bounds.height / 4 : 0
        }
    }
    
    @IBInspectable
    var borderRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.borderRadius
        }
    }
    
    @IBInspectable
    var borderStyle: Bool = false {
        didSet {
            if self.borderStyle {
                self.setCornersStyle()
            }
        }
    }
    
    @IBInspectable
    var shadowStyle: Bool = false {
        didSet {
            if self.shadowStyle {
                self.setShadow()
            }
        }
    }
    
    //MARK: - Publick methods
    override func prepareForInterfaceBuilder() {
       // self.setCornersStyle()
       // self.setShadow()
    }
    
    override func layoutSubviews() {
       // self.setCornersStyle()
      //  self.setShadow()
    }
    
    func setCornersStyle() {
        //self.layer.cornerRadius = self.bounds.height / 4
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
    
    func setShadow() {
        self.layer.shadowColor = UIColor.shadowColorDarkTheme.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowOpacity = 5
    }
    
}
