import UIKit

class DTAdaptiveLabel: UILabel {
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .center
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
