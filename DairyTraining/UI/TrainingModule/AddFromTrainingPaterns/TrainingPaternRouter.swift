import UIKit

final class TrainingPaternRouter: Router {
    
    private weak var rootViewController: TrainingPaternsViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? TrainingPaternsViewController
    }
    
    func pushChoosenPaternViewController(with choosenPatern: TrainingPaternManagedObject) {
        let choosenPaternViewController = self.configureChoosenPaternViewController(with: choosenPatern)
        rootViewController?.navigationController?.pushViewController(choosenPaternViewController, animated: true)
    }
}

private extension TrainingPaternRouter {
    
    func configureChoosenPaternViewController(with choosenPatern: TrainingPaternManagedObject) -> ChoosenPaternViewController {
        let choosenPaternModel = ChoosenPaternModel(patern: choosenPatern)
        let choosenPaternViewModel = ChoosenPaternViewModel(model: choosenPaternModel)
        let choosenPaternViewController = ChoosenPaternViewController(viewModel: choosenPaternViewModel)
        return choosenPaternViewController
    }
}
