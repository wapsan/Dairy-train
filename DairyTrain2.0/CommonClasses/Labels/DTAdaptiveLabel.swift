import UIKit

class DTAdaptiveLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
       // self.
        self.numberOfLines = 0
      //  self.lineBreakMode = .byClipping
        self.textAlignment = .center
        self.textColor = .white

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
