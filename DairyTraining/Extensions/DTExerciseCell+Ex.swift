import UIKit

extension EditableExerciceCell {
    /**
     This property return parent viewcontroller on wich this element is located
    */
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
