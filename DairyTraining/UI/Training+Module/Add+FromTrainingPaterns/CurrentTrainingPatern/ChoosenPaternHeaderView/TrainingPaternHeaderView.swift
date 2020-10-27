//
//  TrainingPaternHeaderView.swift
//  Dairy Training
//
//  Created by Вячеслав on 13.10.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import UIKit

final class TrainingPaternHeaderView: UIView {
    
    //MARK: - @IBOutlets
    @IBOutlet var createTrainingButton: UIButton!
    @IBOutlet var addExerciseButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    //MARK: - Properties
    var createTrainingAction: (() -> Void)?
    var changePaternAction: (() -> Void)?
    
    //MARK: - Initialization
    class func view() -> TrainingPaternHeaderView? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? TrainingPaternHeaderView
    }
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    //MARK: - Setup
    private func setup() {
        setAppereance(for: createTrainingButton)
        setAppereance(for: addExerciseButton)
        
    }
    
    private func setAppereance(for button: UIButton) {
        button.layer.borderColor = DTColors.controllBorderColor.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = DTColors.controllSelectedColor
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8,
                                                left: 8,
                                                bottom: 8,
                                                right: 8)
    }
    
    //MARK: - Actions
    @IBAction func createTrainingButtonAction(_ sender: UIButton) {
        createTrainingAction?()
    }
    
    @IBAction func addExerciseButttonAction(_ sender: UIButton) {
        changePaternAction?()
    }
}
