import XCTest
@testable import Dairy_Training
import CoreData

fileprivate var userService: UserServiceProtocol!

class UserServiceTest: XCTestCase {

    override func setUp() {
        super.setUp()
        let testStoreDescription = NSPersistentStoreDescription()
        testStoreDescription.url = URL(fileURLWithPath: "/dev/null")
        userService = UserInfoService(storeDescription: testStoreDescription)
    }
    
    //MARK: - Update values
    func testUpdateAgeTest() {
        userService.updateUserInfo(.age(age: "18"))
        let userAge = userService.userInfo.age
        XCTAssertEqual(18.int64, userAge)
    }
    
    func testUpdateGenderTest() {
        userService.updateUserInfo(.gender(gender: .male))
        let userGender = userService.userInfo.gender
        XCTAssertEqual(UserInfo.Gender.male.rawValue, userGender)
    }
    
    func testUpdateHeight() {
        userService.updateUserInfo(.height(height: "150"))
        let userHeight = userService.userInfo.heightValue
        XCTAssertEqual(150, userHeight)
    }
    
    func testUpdateWeight() {
        userService.updateUserInfo(.weight(weight: "55"))
        let userWeight = userService.userInfo.weightValue
        XCTAssertEqual(55, userWeight)
    }
    
    func testUpdateActivityLevel() {
        userService.updateUserInfo(.activityLevel(activityLevel: .low))
        let userActivityLevel = userService.userInfo.activityLevel
        XCTAssertEqual(UserInfo.ActivityLevel.low.rawValue, userActivityLevel)
    }
    
    func testUpdateNutritionMode() {
        userService.updateUserInfo(.nutritionMode(nutritionMode: .balanceWeight))
        let nutritionMode = userService.userInfo.nutritionMode
        XCTAssertEqual(UserInfo.NutritionMode.balanceWeight.rawValue, nutritionMode)
    }
    
    func testUpdateDateOfUpdate() {
        userService.updateUserInfo(.updateDate(date: "12.15.12"))
        let dateOfUpdate = userService.userInfo.dateOfLastUpdate
        XCTAssertEqual("12.15.12", dateOfUpdate)
    }
    
    func testDeleteUserData() {
        XCTAssertTrue(userService.cleanUserData())
    }
    
    override func tearDown() {
        super.tearDown()
        userService = nil
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
