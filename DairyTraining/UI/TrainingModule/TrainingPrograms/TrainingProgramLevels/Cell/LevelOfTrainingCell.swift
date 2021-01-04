import UIKit

final class LevelOfTrainingCell: UITableViewCell {

    // MARK: - @IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var levelImageView: UIImageView!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Private methods
    private func setup() {
        levelImageView.layer.cornerRadius = 20
    }
    
    // MARK: - Setter
    func setCell(for trainingLevel: LevelOfTrainingModel) {
        titleLabel.text = trainingLevel.title
    }
}
