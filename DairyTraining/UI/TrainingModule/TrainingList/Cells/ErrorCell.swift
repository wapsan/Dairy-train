import UIKit

final class ErrorCell: UITableViewCell {

    @IBOutlet var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(for errorText: String) {
        errorLabel.text = errorText
    }
}
