import UIKit

final class TrainingPaternsCoordinator: Coordinator {

    // MARK: - Types

    enum Target: CoordinatorTarget {
        case trainingPaternsList
        case paternScreen(trainingPatern: TrainingPaternManagedObject)
    }
    
    // MARK: - Properties

    var window: UIWindow?
    private var navigationController: UINavigationController?
    
    // MARK: - Init

    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
    }
    
    init(window: UIWindow?) {
        self.window = window
    }

    @discardableResult func coordinate(to target: CoordinatorTarget) -> Bool {
        guard let target = target as? Target else { return false }
        switch target {
        case .trainingPaternsList:
            let trainingPaternsListViewController = configureTrainingPaternsViewController()
            let trainingNavigationController = UINavigationController(rootViewController: trainingPaternsListViewController)
            trainingNavigationController.modalPresentationStyle = .fullScreen
            topViewController?.present(trainingNavigationController, animated: true, completion: nil)
            navigationController = trainingNavigationController
        case .paternScreen(trainingPatern: let trainingPatern):
            let paternViewController = configureChoosenPaternViewController(with: trainingPatern)
            navigationController?.pushViewController(paternViewController, animated: true)
        }
        return true
    }
    
    
    // MARK: - Configuration methods
    private func configureTrainingPaternsViewController() -> TrainingPaternsViewController {
        let trainingPaternModel = TrainingPaterModel()
        let trainingPaternViewModel = TrainingPaternViewModel(model: trainingPaternModel)
        let trainingPaternsViewController = TrainingPaternsViewController(viewModel: trainingPaternViewModel)
        trainingPaternViewModel.view = trainingPaternsViewController
        trainingPaternModel.output = trainingPaternViewModel
        return trainingPaternsViewController
    }
    
    private func configureChoosenPaternViewController(with choosenPatern: TrainingPaternManagedObject) -> ChoosenPaternViewController {
        let choosenPaternModel = ChoosenPaternModel(patern: choosenPatern)
        let choosenPaternViewModel = ChoosenPaternViewModel(model: choosenPaternModel)
        let choosenPaternViewController = ChoosenPaternViewController(viewModel: choosenPaternViewModel)
        choosenPaternViewModel.view = choosenPaternViewController
        choosenPaternModel.output = choosenPaternViewModel
        return choosenPaternViewController
    }
}
