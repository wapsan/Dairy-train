import UIKit
import Kingfisher

final class ReadyTrainingCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
    }
    
    func setCell(for item: SpecialWorkout) {
        if let url = item.imageURL {
            backgroundImageView.kf.setImage(with: url)
        }
       // backgroundImageView.image = item.image
        titleLabel.text = item.title
    }
}
