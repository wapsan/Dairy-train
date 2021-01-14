import Foundation

protocol HomeViewModelProtocol: TitledScreenProtocol {
    var menuItemCount: Int { get }
    
    
    func didSelectItemAtIndex(_ index: Int)
    func menuItem(at index: Int) -> HomeModel.MenuItem
    func menuButtonPressed()
}

final class HomeViewModel {
    
    // MARK: - Properties
    private let model: HomeModelProtocol
    
    // MARK: - Initialization
    init(model: HomeModelProtocol) {
        self.model = model
    }
}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
    
    var title: String {
        return "Home"
    }
    
    var description: String {
        return "Welcome, improve you training progress with ghfhfgh!"
    }
    
    func menuButtonPressed() {
        model.showSideMenu()
    }
    
    var menuItemCount: Int {
        return model.menuItems.count
    }
    
    func didSelectItemAtIndex(_ index: Int) {
        return model.callMenuItemAction(for: index)
    }
    
    func menuItem(at index: Int) -> HomeModel.MenuItem {
        return model.getMenuItemForIndex(index: index)
    }
}
