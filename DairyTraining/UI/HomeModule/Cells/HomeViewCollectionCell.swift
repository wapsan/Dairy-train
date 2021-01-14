import UIKit

final class HomeViewCollectionCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var titleLabel: UIImageView!
    
    // MARK: - Properties
    var imageOnAction: (() -> Void)?
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - Setter
    func setCell(for menuItem: HomeModel.MenuItem) {
        descriptionLabel.text = menuItem.titel
    }
}
