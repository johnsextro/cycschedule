//
//  cycscheduleTests.swift
//  cycscheduleTests
//
//  Created by Family on 6/1/15.
//  Copyright (c) 2015 9 Principles. All rights reserved.
//

import UIKit
import XCTest
import cycschedule

class cycscheduleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialViewLoaded() {
        let expectedView = MasterViewController()
        
        XCTAssertNotNil(expectedView.view, "The expected initial view did not load")
    }
    
}
