//
//  MeasureTests.swift
//  MeasureTests
//
//  Created by muukii on 12/24/16.
//  Copyright © 2016 muukii. All rights reserved.
//

import XCTest
@testable import Measure

class MeasureTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
      let measure = MeasureStartPost(name: "Test").start()
      measure.end().print()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
