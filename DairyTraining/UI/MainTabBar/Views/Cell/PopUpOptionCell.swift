//
//  PopUpOptionCell.swift
//  Dairy Training
//
//  Created by cogniteq on 29.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import UIKit

protocol CellRegistrable {
    static var cellID: String { get }
    static var xibName: String { get }
}

extension CellRegistrable {
    static var cellID: String {
        return String(describing: self)
    }
    static var xibName: String {
        return String(describing: self)
    }
}

final class PopUpOptionCell: UITableViewCell, CellRegistrable {

    @IBOutlet var containerView: UIView!
    @IBOutlet var optionImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 20
    }

    func setCell(title: String, and image: UIImage?) {
        titleLabel.text = title
        optionImageView.image = image
    }
}
