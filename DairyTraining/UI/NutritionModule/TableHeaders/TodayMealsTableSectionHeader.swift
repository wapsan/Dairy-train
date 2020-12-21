import UIKit

final class TodayMealsTableSectionHeader: UIView {
    
    
    @IBOutlet var title: UILabel!
    
    static func view() -> TodayMealsTableSectionHeader? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? TodayMealsTableSectionHeader
    }
}
 
