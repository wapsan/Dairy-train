//
//  WorkoutListTableHeader.swift
//  Dairy Training
//
//  Created by cogniteq on 12.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import UIKit

final class WorkoutListTableHeader: UIView {
  
    var timePeriodIndexWasChanged: ((_ index: Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
 
    @IBAction func segmentControllValueChanged(_ sender: UISegmentedControl) {
        timePeriodIndexWasChanged?(sender.selectedSegmentIndex)
    }
}

extension UIView {

    static func loadFromXib() -> Self? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? Self
    }
}

