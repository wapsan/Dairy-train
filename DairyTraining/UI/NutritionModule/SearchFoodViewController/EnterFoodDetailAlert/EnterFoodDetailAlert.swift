//
//  EnterFoodDetailAlert.swift
//  Dairy Training
//
//  Created by cogniteq on 19.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import UIKit

final class EnterFoodDetailAlert: UIView {
    
   
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var foodNameLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var textField: UITextField!
    
    // MARK: - Initialization
        static func view() -> EnterFoodDetailAlert? {
            let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
            return nib?.first as? EnterFoodDetailAlert
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
     
        }
        
        // MARK: - Publick methods
    func showWith(for foof: Food) {
        foodNameLabel.text = foof.label.capitalized
        textField.becomeFirstResponder()
        textField.keyboardType = .numberPad
            guard let topViewController = UIApplication.topViewController() else { return }
            self.translatesAutoresizingMaskIntoConstraints = false
            guard let tabbarController = topViewController.tabBarController,
                  let tabbarviee = tabbarController.view else {
                return
            }
            tabbarviee.addSubview(self)
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: tabbarviee.topAnchor),
                self.leftAnchor.constraint(equalTo: tabbarviee.leftAnchor),
                self.rightAnchor.constraint(equalTo: tabbarviee.rightAnchor),
                self.bottomAnchor.constraint(equalTo: tabbarviee.bottomAnchor)
            ])
            animatiInAlert()
        }
        
//        // MARK: - Private methods
//        private func setup() {
//
//
//        }
        
        
        private func animatiInAlert() {
            containerView.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 0.5
                self.containerView.alpha = 1
            }, completion: nil)
        }
        
        private func hideAlert() {
            animateoutAlert()
        }
        
        private func animateoutAlert() {
            textField.resignFirstResponder()
            UIView.animate(
                withDuration: 0.3, delay: 0, options: .curveEaseOut,
                animations: {
                    self.backgroundView.alpha = 0.0
                    self.containerView.alpha = 0.0
                }, completion: { _ in
                    self.removeFromSuperview()
                })
        }
        
        
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        hideAlert()
    }
    
}
