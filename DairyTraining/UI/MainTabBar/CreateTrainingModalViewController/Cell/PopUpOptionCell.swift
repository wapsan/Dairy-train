import UIKit

final class PopUpOptionCell: UITableViewCell {

    private lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(tapAction))
    }()
    
    // MARK: - @IBOutlets
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var optionImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    var action: (() -> Void)?
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        optionImageView.addGestureRecognizer(tapGesture)
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 20
    }
    
    // MARK: - Setter
    func setCell(title: String, and image: UIImage?) {
        titleLabel.text = title
        optionImageView.image = image
    }
    
    @objc private func tapAction() {
        action?()
    }
    
}
