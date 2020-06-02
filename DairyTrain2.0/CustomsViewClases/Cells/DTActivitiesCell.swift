import UIKit

class DTActivitiesCell: UITableViewCell {

    
    static var cellID: String = "DTActivitiesCell"
    
    @IBOutlet weak var cellView: DTViewWithCorners!
    @IBOutlet weak var muscleGroupImage: UIImageView!
    @IBOutlet weak var tittle: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.setImage()
    }
    
    private func setImage() {
        self.muscleGroupImage.layer.borderColor = UIColor.white.cgColor
        self.muscleGroupImage.layer.borderWidth = 1
        self.muscleGroupImage.layer.cornerRadius = self.muscleGroupImage.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
