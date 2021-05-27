import XCTest
@testable import Dairy_Training

class HomeMockInteractor: HomeInteractorProtocol {
    
    var menuItems: [HomeInteractor.MenuItem] = HomeInteractor.MenuItem.allCases
    var itemFoIndexPath: HomeInteractor.MenuItem? = nil
    
    func getMenuItemForIndex(index: Int) -> HomeInteractor.MenuItem {
        itemFoIndexPath = menuItems[index]
        return menuItems[index]
    }
}

class HomeMockRouter: HomeRouterProtocol {
    
    var selectedMenuItem: HomeInteractor.MenuItem? = nil
    var isMenuShown: Bool = false
    
    func showSideMenu() {
        isMenuShown = true
    }
    
    func showExerciseFlow() {
        selectedMenuItem = .createTrainingFromExerciseList
    }
    
    func showWorkoutsPaternFlow() {
        selectedMenuItem = .createTrainingFromTrainingPatern
    }
    
    func showReadyWorkoutsFlow() {
        selectedMenuItem = .createTrainingFromSpecialTraining
    }
    
    func showSearchFoodFlow() {
        selectedMenuItem = .addMeal
    }
    
    func showMonthlyStatisticsScreen() {
        selectedMenuItem = .mounthlyStatistics
    }
}

class HomePresenterTest: XCTestCase {

    var homePresenter: HomePresenter!
    var mockIteractor: HomeMockInteractor!
    var mockRouter: HomeMockRouter!
    
    var homeModel: [HomeInteractor.MenuItem]!
    
    override func setUpWithError() throws {
        mockRouter = HomeMockRouter()
        mockIteractor = HomeMockInteractor()
        homePresenter = HomePresenter(interactor: mockIteractor)
        homePresenter.router = mockRouter
        homeModel = HomeInteractor.MenuItem.allCases
    }

    override func tearDownWithError() throws {
        mockIteractor = nil
        homePresenter = nil
        mockRouter = nil
        homeModel = nil
    }
    
    func testTitle() {
        XCTAssertEqual(homePresenter.title, "Home")
    }
    
    func testDescription() {
        XCTAssertEqual(homePresenter.description, "Welcome, improve you training progress with gym core!")
    }
    
    func testMenuItemsCount() {
        XCTAssertEqual(homePresenter.menuItemCount, homeModel.count)
    }

    func testMenuItemAtIndex() {
        let indexPath = IndexPath(row: 0, section: 0)
        let itemFromPresenter = homePresenter.menuItem(at: indexPath)
        let itemFromModel = homeModel[indexPath.row]
        XCTAssertEqual(itemFromPresenter, itemFromModel)
        XCTAssertEqual(mockIteractor.itemFoIndexPath, itemFromModel)
    }
    
    func testMenuButton() {
        homePresenter.menuButtonPressed()
        XCTAssertTrue(mockRouter.isMenuShown)
    }
    
    func testSelectMenuItem() {
        let indexPath = IndexPath(row: 1, section: 0)
        homePresenter.didSelectItemAtIndex(indexPath)
        XCTAssertEqual(mockRouter.selectedMenuItem, homeModel[indexPath.row])
    }
}
