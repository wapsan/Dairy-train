import UIKit

final class WorkoutListTableHeader: UIView {
  
    var timePeriodIndexWasChanged: ((_ index: Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
 
    @IBAction func segmentControllValueChanged(_ sender: UISegmentedControl) {
        timePeriodIndexWasChanged?(sender.selectedSegmentIndex)
    }
}
