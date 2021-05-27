//
//  MainTabBarPresenterTest.swift
//  Dairy TrainingTests
//
//  Created by cogniteq on 21.05.21.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import XCTest
@testable import Dairy_Training

class MockRouter: MainTabBarRouterProtocol {
    
    var isPopUpScreebShown = false
    
    func showCreateTrainingoptionsPopUpScreen() {
        isPopUpScreebShown = true
    }
}

class MainTabBarPresenterTest: XCTestCase {

    var mockRouter: MockRouter!
    var mainTabBarPresenter: MainTabBarPresenter!
    var mainTabBarInteractor: MainTabBarModel!
    
    var controllers: [MainTabBarModel.Controller]!
    
    override func setUpWithError() throws {
        mockRouter = MockRouter()
        mainTabBarInteractor = MainTabBarModel()
        mainTabBarPresenter = MainTabBarPresenter(model: mainTabBarInteractor)
        mainTabBarPresenter.router = mockRouter
        controllers = MainTabBarModel.Controller.allCases
       
    }
    
    func testPlusButton() {
        mainTabBarPresenter.centeredAddButtonPressed()
        XCTAssertTrue(mockRouter.isPopUpScreebShown)
    }
    
    func testDefaultTabIndex() {
        let defaultTabIndex = MainTabBarModel.Controller.home.controllerIndex
        XCTAssertEqual(defaultTabIndex, mainTabBarPresenter.defaultControllerIndex)
    }

    func testControllersCount() {
        let controllers = MainTabBarModel.Controller.allCases
        XCTAssertEqual(controllers.count, mainTabBarPresenter.viewControllers.count)
    }
    
    override func tearDownWithError() throws {
        mockRouter = nil
        mainTabBarInteractor = nil
        mainTabBarPresenter = nil
        controllers = nil
    }
}
