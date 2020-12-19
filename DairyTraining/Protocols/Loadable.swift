import ZKProgressHUD

protocol Loadable {
    func showLoader()
    func hideLoader()
}

extension Loadable {
    
    func showLoader() {
        ZKProgressHUD.show()
    }
    
    func hideLoader() {
        ZKProgressHUD.dismiss()
    }
}
