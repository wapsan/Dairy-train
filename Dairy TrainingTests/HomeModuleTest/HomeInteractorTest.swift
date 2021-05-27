import XCTest
@testable import Dairy_Training

class HomeInteractorTest: XCTestCase {

    var homeInteractor: HomeInteractorProtocol!
    var homeModel: [HomeInteractor.MenuItem]!
    
    override func setUpWithError() throws {
        homeInteractor = HomeInteractor()
        homeModel = HomeInteractor.MenuItem.allCases
    }

    override func tearDownWithError() throws {
        homeInteractor = nil
        homeModel = nil
    }

    func testMenuItemAtIndex() {
        let index = 1
        let menuItemAtIndex = homeInteractor.getMenuItemForIndex(index: 1)
        XCTAssertEqual(menuItemAtIndex, homeModel[index])
    }
    
    func testAllMenuItems() {
        XCTAssertEqual(homeInteractor.menuItems, homeModel)
    }
}
