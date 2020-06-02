import UIKit

class AlertHelper {
    
    //MARK: - Properties
    static var shared = AlertHelper()
    
    //MARK: - Publick methods
    func showAllertOn(_ viewController: UIViewController,
                      tittle: String?,
                      message: String,
                      cancelTittle: String?,
                      okTittle: String?,
                      style: UIAlertController.Style,
                      complition: (() -> Void)?) {
       
        let alert = UIAlertController(title: tittle, message: message , preferredStyle: style)
        let okAction = UIAlertAction(title: okTittle, style: .default, handler: { ( _ ) in
            guard let complition = complition else { return }
            complition()
        })
        alert.addAction(okAction)
        if let cancelTittle = cancelTittle {
            let cancelAction = UIAlertAction(title: cancelTittle, style: .default, handler: nil)
            alert.addAction(cancelAction)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
