import UIKit

class SideMenuCell: UITableViewCell {

    //MARK: - Properties
    static let cellID = "SideMenuCell"
    static let xibName = "SideMenuCell"
    
    //MARK: - @IBOutlets
    @IBOutlet var menuItemTitleLabel: UILabel!
    @IBOutlet var menuItemImageView: UIImageView!
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    //MARK: - Setup
    func setCell(for menuItem: SideMenuItem) {
        menuItemImageView.image = menuItem.image
        menuItemTitleLabel.text = menuItem.title
    }
}
