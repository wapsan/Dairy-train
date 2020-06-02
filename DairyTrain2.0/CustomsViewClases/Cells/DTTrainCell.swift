

import UIKit

class DTTrainCell: UICollectionViewCell {
    
    static var cellID = "DTTrainCell"
    
    //MARK: - @IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var gropIcons: [UIImageView]!
    
    //MARK: - Private methods
    private func hideIcons() {
        for icon in self.gropIcons {
            icon.isHidden = true
        }
    }
    
    //MARK: - Publick methods
    func setGroupIcons(by groups: [MuscleGroup.Group]) {
        self.hideIcons()
        if self.gropIcons.count >= groups.count {
            for (index, group) in groups.enumerated() {
                self.gropIcons[index].image = group.image
                self.gropIcons[index].isHidden = false
            }
        } else {
            for (index, icon) in self.gropIcons.enumerated() {
                icon.image = groups[index].image
                icon.isHidden = false
            }
        }
    }
    
}
