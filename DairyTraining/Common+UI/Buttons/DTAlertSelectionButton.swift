import UIKit

class DTAlertSelectionButton: UIButton {
    
    //MARK: - Properties
    var infovalue: String?
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
