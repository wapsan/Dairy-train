import UIKit

class DTAdaptiveLabel: UILabel {
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.1
        self.numberOfLines = 1
        self.baselineAdjustment = .alignCenters
        self.textAlignment = .center
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
