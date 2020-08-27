import UIKit

final class MuscleSubgropsRouter: Router {
    
    private weak var rootViewController: MuscleSubgroupsViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? MuscleSubgroupsViewController
    }
}


private extension MuscleSubgropsRouter {
    
}
