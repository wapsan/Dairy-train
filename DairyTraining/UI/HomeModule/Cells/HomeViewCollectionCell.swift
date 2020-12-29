import UIKit

final class HomeViewCollectionCell: UICollectionViewCell {

    // MARK: - Cell properties
    static let cellID = "HomeViewCollectionCell"
    static let xibName = "HomeViewCollectionCell"
    
    // MARK: - @IBOutlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleLabel: UIImageView!
    
    // MARK: - Properties
    var imageOnAction: (() -> Void)?
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20
    }
    
    func setCell(for menuItem: HomeMenuItem) {
        descriptionLabel.text = menuItem.titel
    }
    
}
