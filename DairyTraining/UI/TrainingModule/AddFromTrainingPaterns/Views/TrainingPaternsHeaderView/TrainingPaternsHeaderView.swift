import UIKit

final class TrainingPaternsHeaderView: UIView {
    
    @IBOutlet var tittle: UILabel!
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    class func view() -> TrainingPaternsHeaderView? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? TrainingPaternsHeaderView
    }
    
    
    
    
}

private extension TrainingPaternsHeaderView {
    func setup() {
        self.backgroundColor = DTColors.backgroundColor
    }
}
