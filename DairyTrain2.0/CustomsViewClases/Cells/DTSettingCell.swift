
import UIKit

class DTSettingCell: UITableViewCell {

    @IBOutlet weak var markImage: UIImageView!
    @IBOutlet weak var mainSettingLabel: UILabel!
    @IBOutlet weak var currentsSetting: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
