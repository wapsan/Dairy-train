import UIKit

final class SideMenuCell: UITableViewCell {

    //MARK: - @IBOutlets
    @IBOutlet var menuItemTitleLabel: UILabel!
    @IBOutlet var menuItemImageView: UIImageView!
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Setup
    func setCell(for menuItem: SideMenuInteractor.MenuItem) {
        menuItemImageView.image = menuItem.image
        menuItemTitleLabel.text = menuItem.title
    }
}
