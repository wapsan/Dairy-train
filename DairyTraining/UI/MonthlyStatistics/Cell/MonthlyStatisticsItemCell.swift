import UIKit

final class MonthlyStatisticsItemCell: UICollectionViewCell {
    
    //MARK: - @IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var infoButton: UIButton!
    
    @IBOutlet private var trailingContainerConstraint: NSLayoutConstraint!
    @IBOutlet private var leadingContainerConstraint: NSLayoutConstraint!
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    //MARK: - Setter
    func configure(for entity: MonthlyStatisticsModel.Entity, indexPath: IndexPath) {
        titleLabel.text = entity.title
        descriptionLabel.text = entity.description
        valueLabel.text = entity.value.string
        infoButton.isHidden = true
        
        
        guard indexPath.row != 0 else { setupOddCellConstraints(); return }
        indexPath.row % 2 == 0 ? setupOddCellConstraints() : setupEvenCellConstraints()
    }
    
    
    //MARK: - Private methods
    private func setup() {
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = .brown
    }
    
    private func setupOddCellConstraints() {
        leadingContainerConstraint.constant = 16
        trailingContainerConstraint.constant = 8
    }
    
    private func setupEvenCellConstraints() {
        leadingContainerConstraint.constant = 8
        trailingContainerConstraint.constant = 16
    }
    
    //MARK: - Actions
    @IBAction func infoButtonPressed(_ sender: Any) {
        
    }
}
