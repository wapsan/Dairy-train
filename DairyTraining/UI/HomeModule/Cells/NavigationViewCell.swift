import UIKit

final class NavigationViewCell: UICollectionViewCell, CellRegistrable {

    // MARK: - @IBOutlets
    @IBOutlet private var menuButton: UIButton!
    
    // MARK: - Properties
    var menuOnAction: (() -> Void)?
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Lyfecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        menuButton.layer.cornerRadius = menuButton.bounds.height / 4
    }
    
    // MARK: - Private methods
    private func setup() {
        menuButton.layer.borderWidth = 1
        menuButton.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: - Actions
    @IBAction func menuButtonAction(_ sender: Any) {
        menuOnAction?()
    }
}
