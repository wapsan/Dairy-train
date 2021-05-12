import UIKit

final class PopUpOptionCell: UITableViewCell {

    // MARK: - @IBOutlets
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var optionImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 20
    }
    
    // MARK: - Setter
    func configureCell(for option: AddPopUpInteractor.Option) {
        titleLabel.text = option.title
        optionImageView.image = option.image
    }
    
    func setCell(title: String, and image: UIImage?) {
        titleLabel.text = title
        optionImageView.image = image
    }
}
