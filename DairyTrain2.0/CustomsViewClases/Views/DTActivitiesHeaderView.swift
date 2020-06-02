import UIKit

class DTActivitiesHeaderView: UIView {
    
    @IBOutlet weak var tittle: UILabel!
    @IBOutlet var backgrounView: UIView!
    
    
    //MARK: - Initialization
       override init(frame: CGRect) {
           super.init(frame: frame)
           self.loadFromNib()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           self.loadFromNib()
       }
    
}
