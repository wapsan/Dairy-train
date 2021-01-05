//
//  DefaultExerciseCell.swift
//  Dairy Training
//
//  Created by cogniteq on 05.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import UIKit

final class DefaultExerciseCell: UITableViewCell {

    @IBOutlet var promptLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subgroupImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        
    }

    func setCell(for exercise: Groupable) {
        nameLabel.text = exercise.name
        promptLabel.text = exercise.promptDescription
        subgroupImage.image = exercise.image
    }
}
