import UIKit


extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cell: T.Type) {
        let nib = UINib(nibName: cell.xibName, bundle: nil)
        let cellID = cell.cellID
        self.register(nib, forCellWithReuseIdentifier: cellID)
    }
}

extension UICollectionViewCell {
    
    static var cellID: String {
        return String(describing: self)
    }
    
    static var xibName: String {
        return String(describing: self)
    }
    
    func `as`<T: UICollectionViewCell>(type: T.Type) -> T? {
        return self as? T
    }
}
