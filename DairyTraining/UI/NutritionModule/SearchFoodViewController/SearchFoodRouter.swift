
import UIKit

protocol SearchFoodRouterProtocol {
    func hideSearchFoodFlow()
}

final class SearchFoodRouter: Router {
    
    private let rootViewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
    
    
}

extension SearchFoodRouter: SearchFoodRouterProtocol {
    
    func hideSearchFoodFlow() {
        rootViewController.dismiss(animated: true, completion: nil)
    }
}

