//
//  ReadyTrainingCell.swift
//  Dairy Training
//
//  Created by cogniteq on 04.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

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
        backgroundImageView.image = item.image
        titleLabel.text = item.title
    }
}
