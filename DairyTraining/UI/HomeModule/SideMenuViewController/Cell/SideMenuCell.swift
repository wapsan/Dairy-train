import UIKit

class SideMenuCell: UITableViewCell {

    
    //MARK: - @IBOutlets
    @IBOutlet var menuItemTitleLabel: UILabel!
    @IBOutlet var menuItemImageView: UIImageView!
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    //MARK: - Setup
    func setCell(for menuItem: SideMenuModel.MenuItem) {
        menuItemImageView.image = menuItem.image
        menuItemTitleLabel.text = menuItem.title
    }
}
