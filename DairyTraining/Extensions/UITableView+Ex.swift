import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cell: T.Type) {

        let nib = UINib(nibName: cell.xibName, bundle: nil)
        let cellID = cell.cellID
        self.register(nib, forCellReuseIdentifier: cellID)
    }
    
}

extension UITableViewCell  {
    
    static var cellID: String {
        return String(describing: self)
    }
    
    static var xibName: String {
        return String(describing: self)
    }
    
    func `as`<T: UITableViewCell>(type: T.Type) -> T? {
        return self as? T
    }
}

