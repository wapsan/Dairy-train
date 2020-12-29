import Foundation

protocol HomeViewModelProtocol {
    var menuItemCount: Int { get }
    
    func didSelectItemAtIndex(_ index: Int)
    func menuItem(at index: Int) -> HomeMenuItem
    func menuButtonPressed()
}

final class HomeViewModel {
    
    private let model: HomeModelProtocol
    
    init(model: HomeModelProtocol) {
        self.model = model
    }
    
}

extension HomeViewModel: HomeViewModelProtocol {
    
    func menuButtonPressed() {
        model.showSideMenu()
    }
    
    var menuItemCount: Int {
        return model.menuItems.count
    }
    
    func didSelectItemAtIndex(_ index: Int) {
        return model.callMenuItemAction(for: index)
    }
    
    func menuItem(at index: Int) -> HomeMenuItem {
        return model.getMenuItemForIndex(index: index)
    }
}
