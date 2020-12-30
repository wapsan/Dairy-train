import UIKit

extension UITableView {
    
    func register(cell: CellRegistrable.Type) {
        let nib = UINib(nibName: cell.xibName, bundle: nil)
        let cellID = cell.cellID
        self.register(nib, forCellReuseIdentifier: cellID)
    }
    
}
