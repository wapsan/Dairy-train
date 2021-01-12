import UIKit

final class DefaultExerciseCell: UITableViewCell {

    // MARK: - @IBOutlets
    @IBOutlet private var promptLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var subgroupImage: UIImageView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var promtContainer: UIStackView!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Lyfecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        subgroupImage.layer.cornerRadius = subgroupImage.bounds.height / 2
    }
    
    // MARK: - Private setup
    private func setup() {
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = DTColors.controllBorderColor.cgColor
    }

    // MARK: - Setter
    func setCell(for exercise: Groupable) {
        nameLabel.text = exercise.name
        promptLabel.text = exercise.promptDescription
        subgroupImage.image = exercise.image
        promtContainer.isHidden = exercise.promptDescription == nil
    }
    
    func setUnselectedBackgroundColor() {
        self.containerView.backgroundColor = DTColors.controllUnselectedColor
    }
    
    func setSelectedBackgroundColor() {
        self.containerView.backgroundColor = DTColors.controllSelectedColor
    }
}
