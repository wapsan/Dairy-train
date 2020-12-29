import UIKit

final class NavigationViewCell: UICollectionViewCell {

    static let cellID = "NavigationViewCell"
    static let xibName = "NavigationViewCell"
    
    @IBOutlet var menuButton: UIButton!
    
    var menuOnAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        menuButton.layer.cornerRadius = menuButton.bounds.height / 4
    }
    
    private func setup() {
        menuButton.layer.borderWidth = 1
        menuButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        menuOnAction?()
    }
}
