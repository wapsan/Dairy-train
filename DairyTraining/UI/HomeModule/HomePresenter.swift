import Foundation

protocol HomePresenterProtocol: TitledScreenProtocol {
    func menuItem(at indexPath: IndexPath) -> HomeInteractor.MenuItem
    var menuItemCount: Int { get }
    
    func didSelectItemAtIndex(_ indexPath: IndexPath)
    func menuButtonPressed()
}

final class HomePresenter {
    
    // MARK: - Internal properties
    private let interactor: HomeInteractorProtocol
    var router: HomeRouterProtocol?
    
    // MARK: - Initialization
    init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
    }
}

// MARK: - HomeViewModelProtocol
extension HomePresenter: HomePresenterProtocol {
    
    func menuItem(at indexPath: IndexPath) -> HomeInteractor.MenuItem {
        return interactor.getMenuItemForIndex(index: indexPath.row)
    }
    
    func didSelectItemAtIndex(_ indexPath: IndexPath) {
        let menuItem = interactor.getMenuItemForIndex(index: indexPath.row)
        
        switch menuItem {
        case .createTrainingFromExerciseList:
            router?.showExerciseFlow()
            
        case .createTrainingFromTrainingPatern:
            router?.showWorkoutsPaternFlow()
            
        case .createTrainingFromSpecialTraining:
            router?.showReadyWorkoutsFlow()
            
        case .addMeal:
            router?.showSearchFoodFlow()
            
        case .mounthlyStatistics:
            router?.showMonthlyStatisticsScreen()
            
        }
    }

    var title: String {
        return "Home"
    }
    
    var description: String {
        return "Welcome, improve you training progress with ghfhfgh!"
    }
    
    func menuButtonPressed() {
        router?.showSideMenu()
    }
    
    var menuItemCount: Int {
        return interactor.menuItems.count
    }
}
