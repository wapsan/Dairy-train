import UIKit

class AlertHelper {
    
    //MARK: - Properties
    static var shared = AlertHelper()
    
    //MARK: - Initialization
    private init() {}
    
    //MARK: - Publick methods
    func showDefaultAlert(on viewController: UIViewController,
                      title: String?,
                      message: String?,
                      cancelTitle: String?,
                      okTitle: String?,
                      style: UIAlertController.Style,
                      completion: (() -> Void)?) {
       
        let alert = UIAlertController(title: title, message: message , preferredStyle: style)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { ( _ ) in
            guard let completion = completion else { return }
            completion()
        })
        alert.addAction(okAction)
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: nil)
            alert.addAction(cancelAction)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
