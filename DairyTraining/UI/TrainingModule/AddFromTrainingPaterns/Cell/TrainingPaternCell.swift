import UIKit

class TrainingPaternCell: UITableViewCell {

    //MARK: - @IBOutlets
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var trainingPaternTittleLabel: UILabel!
    

    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
 
    //MARK: - Setup
    func setup() {
        self.selectionStyle = .none
        self.containerView.backgroundColor = DTColors.controllUnselectedColor
    }

    //MARK: - Lifecycle
    override func layoutSubviews() {
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = DTColors.controllBorderColor.cgColor
        self.containerView.layer.cornerRadius = 20
        super.layoutSubviews()
    }
    
    //MARK: - Setter
    func setCell(for paternName: String) {
        self.trainingPaternTittleLabel.text = paternName
    }
}
