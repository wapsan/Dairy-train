import UIKit

final class NutritionModeCell: UITableViewCell {


    
    // MARK: - @IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var checkmarkImageView: UIImageView!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        checkmarkImageView.isHidden = true
    }

    func setCellName(_ name: String) {
        titleLabel.text = name
    }
    
    func showCheckMark() {
        checkmarkImageView.isHidden = false
    }
    
    func hideCheckMark() {
        checkmarkImageView.isHidden = true
    }
}
