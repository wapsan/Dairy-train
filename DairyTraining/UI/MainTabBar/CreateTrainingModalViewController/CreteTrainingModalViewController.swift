//
//  CreteTrainingModalViewController.swift
//  Dairy Training
//
//  Created by cogniteq on 30.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import UIKit

final class CreteTrainingModalViewController: UIViewController {

    @IBOutlet private var modalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
    }


    @IBAction func viewDragging(_ sender: UIPanGestureRecognizer) {
      //  guard sender.state == .began || sender.state == .changed else { return }
        let translationY = sender.translation(in: view).y
        guard translationY > 0 else { return }
        
        let bottomEdgeToDismiss = view.bounds.size.height - (view.bounds.size.height * 0.2)
        modalView.transform = .init(translationX: 0, y: translationY)
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: {
                self.modalView.transform = .identity
            })
        }
        
        if modalView.frame.origin.y >= bottomEdgeToDismiss {
            dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
}
