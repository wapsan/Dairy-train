import UIKit

extension UIView {

    static func loadFromXib() -> Self? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? Self
    }
}
