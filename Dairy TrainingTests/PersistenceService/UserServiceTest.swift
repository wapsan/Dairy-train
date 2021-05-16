//
//  UserServiceTest.swift
//  Dairy TrainingTests
//
//  Created by cogniteq on 16.05.21.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import XCTest
@testable import Dairy_Training

var mokUserService: UserServiceProtocol!

class UserServiceTest: XCTestCase {

    override func setUpWithError() throws {
        mokUserService = UserInfoService(storeType: .test)
    }
    
    func testSetUserAge() {
        mokUserService.updateUserInfo(.age(age: "20"))
        XCTAssertEqual(mokUserService.userInfo.age, 20)
    }
    
    

    override func tearDownWithError() throws {
        mokUserService = nil
    }

    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
