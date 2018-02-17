//
//  DateExtensionsTest.swift
//  smart-kuk-common-libraryTests
//
//  Created by SmartKuk on 2/17/18.
//  Copyright © 2018 SmartCompany. All rights reserved.
//

import XCTest
@testable import smart_kuk_common_library

class DateExtensionsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
    }
    
    func testFormatting() {
        let compareStr = "2018-01-01"
        let knownDate = getDate(strDate: compareStr)
        XCTAssert(compareStr == knownDate.formatting())
        XCTAssert(compareStr != knownDate.formatting(format: "HH:mm:ss"))
    }
    
    func testDayAndWeekday() {
        let base = "2018-02-"
        let days = ["17": "토",
                    "18": "일",
                    "19": "월",
                    "20": "화",
                    "21": "수",
                    "22": "목",
                    "23": "금"]
        
        for (day, weekday) in days {
            let knownDate = getDate(strDate: base + day)
            let dayweek = knownDate.dayAndWeekday()
            debugPrint("dayweek:\(dayweek)")
            XCTAssert(dayweek[0] == day && dayweek[1] == weekday)
        }
    }
    
    func testToWeekday() {
        let base = "2018-02-"
        let days = ["17": "토",
                    "18": "일",
                    "19": "월",
                    "20": "화",
                    "21": "수",
                    "22": "목",
                    "23": "금"]
        
        for (day, weekday) in days {
            let knownDate = getDate(strDate: base + day)
            let name = knownDate.toWeekday()
            debugPrint("dayweek:\(name)")
            XCTAssert(weekday == name)
        }
    }
    
    func testToWeekdayNumber() {
//        toWeekdayNumber
        endOfMarket
    }
    
    private func getDate(strDate: String = "2018-02-17") -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")!
        return format.date(from: strDate)!
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
}
