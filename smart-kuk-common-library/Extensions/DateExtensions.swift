//
//  DateExtensions.swift
//  SmartStockMemo
//
//  Created by SmartKuk on 1/16/18.
//  Copyright © 2018 SmartCompany. All rights reserved.
//

import Foundation

extension Date {
    
    /**
     self Date 객체를 사용자가 원하는 날짜-시간 문자열 포맷으로 리턴
     - parameter format: 문자열 타입의 날짜 포맷
     - returns: 포맷 문자열을 기준으로 포맷팅 되어 변환된 문자열
     */
    func formatting(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = createDateFormatter(format: format)
        return dateFormatter.string(from: self)
    }
    
    /**
     self Date 객체를 일, 요일 형태의 문자열 배열로 리턴
     - returns: 사이즈 2 짜리 배열 첫번째는 날짜 두번째는 요일
     */
    func dayAndWeekday() -> [String] {
        let dateFormatter = createDateFormatter(format: "dd")
        var results = [String]()
        results.append(dateFormatter.string(from: self))
        results.append(self.toWeekday())
        return results
    }
    
    /**
     Date 객체의 요일을 문자열로 리턴
     - returns: 요일 숫자에 대한 한글명칭 문자열
     */
    func toWeekday() -> String {
        let weekdayDic: [Int: String] = [
            1: "일", 2: "월", 3: "화", 4: "수", 5: "목", 6: "금", 7: "토"
        ]
        let cal = Calendar(identifier:.gregorian)
        let comps = cal.dateComponents([.weekday], from: self)
        if let weekdayNumber = comps.weekday {
            return weekdayDic[weekdayNumber]!
        }
        return ""
    }
    
    /**
     현재 요일을 숫자로 리턴
     - returns : 요일에 대한 숫자값 1부터 일요일 7은 토요일
     */
    func toWeekdayNumber() -> Int {
        let cal = Calendar(identifier:.gregorian)
        let comps = cal.dateComponents([.weekday], from: self)
        if let weekdayNumber = comps.weekday {
            return weekdayNumber
        }
        return 0
    }
    
    /**
     장마감인지 판단하고 결과를 리턴
     - returns: true 이면 장마감
     */
    func endOfMarket() -> Bool {
        
        let now = Date()
        let cal = Calendar(identifier:.gregorian)
        let comps = cal.dateComponents([.weekday], from: now)
        if let weekdayNumber = comps.weekday {
            if weekdayNumber == 1 || weekdayNumber == 7 {
                return true
            }
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let startTime = "\(dateFormatter.string(from: now)) 09:00:00"
        let endTime = "\(dateFormatter.string(from: now)) 15:00:00"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let starttime = dateFormatter.date(from: startTime), let endtime = dateFormatter.date(from: endTime) {
            if !(starttime <= now && now <= endtime) {
                return true
            }
        }
        
        return false
    }
    
    /**
     거래 가능 시간인지 판단하고 결과를 리턴
     - returns: true 거래 가능으로 판단
     */
    func tradeable() -> Bool {
        
        let weeknum = self.toWeekdayNumber()
        if weeknum == 1 || weeknum == 7 {
            return false
        }
        
        //거래 가능시간(정규 거래시간만 범위로 셋팅)
        let tradingRange = ["09:00:00", "15:30:00"]
        let from = "\(self.formatting(format: "yyyy-MM-dd")) \(tradingRange[0])"
        let to = "\(self.formatting(format: "yyyy-MM-dd")) \(tradingRange[1])"
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let starttime = dateFormatter.date(from: from), let endtime = dateFormatter.date(from: to) {
            return starttime <= self && self <= endtime
        }
        
        return false
    }
    
    /**
     오늘을 기준으로 장마감 시간 이전인지 판단하고 결과를 리턴
     - returns: true 이면 오늘 장마감 날짜 시간보다 작음(갱신 필요)
     */
    func lessThanClosingMarket() -> Bool {
        
        let endTime = "18:00:00"
        let now = Date()
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let closingDateTime = dateFormatter.date(from: "\(now.formatting(format: "yyyy-MM-dd")) \(endTime)") {
            return self < closingDateTime
        }
        
        return false
    }
    
    /**
     Date 객체가 함수 호출 시점 현재일자와 동일한지 검사하여 결과를 리턴
     - returns : 참은 오늘, 거짓은 오늘 아님
     */
    func isToday() -> Bool {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let now = Date()
        return dateFormatter.string(from: self) == dateFormatter.string(from: now)
    }
    
    /**
     Date 객체를 현재 호출 시점 Date 객체와 년,월,일 기간 산출
     */
    func elapseUnits() -> (Int, Int, Int) {
        
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.locale = Locale(identifier: "ko_KR")
        cal.timeZone = TimeZone(abbreviation: "KST")!
        
        var year = 0
        var month = 0
        var day = 0
        
        let datecomp = cal.dateComponents([.year, .month, .day], from: self, to: Date())
        if let val = datecomp.year {
            year = val
        }
        if let val = datecomp.month {
            month = val
        }
        if let val = datecomp.day {
            day = val
        }
        
        return (year, month, day)
    }
    
    /**
     elapseUnits 함수를 이용하여 나온 결과를 화면에 보여주기 위해 보기 좋게 문자열로 변환
     - returns: 1년 10개월 5일 형태의 문자열
     */
    func elapseUnitNames() -> String {
        var names = ""
        let elapseUnits = self.elapseUnits()
        debugPrint("elapseUnits:\(elapseUnits)")
        if elapseUnits.0 > 0 {
            names += "\(elapseUnits.0)년"
        }
        if elapseUnits.1 > 0 {
            names = names.notEmptyAppend() + "\(elapseUnits.1)개월"
        }
        if elapseUnits.2 > 0 {
            names = names.notEmptyAppend() + "\(elapseUnits.2)일"
        }
        return names
    }
    
    
    
    
    
    func startOfMonth() -> Date {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        cal.timeZone = TimeZone(abbreviation: "KST")!
        return cal.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        cal.timeZone = TimeZone(abbreviation: "KST")!
        return cal.date(byAdding: DateComponents(month: 1, day: -1, second: -1), to: self.startOfMonth())!
    }
    
    func getPreviousMonth() -> Date? {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        cal.timeZone = TimeZone(abbreviation: "KST")!
        return cal.date(byAdding: .month, value: -1, to: self)
    }
    
    func getNextMonth() -> Date? {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        cal.timeZone = TimeZone(abbreviation: "KST")!
        return cal.date(byAdding: .month, value: 1, to: self)
    }
    
    /**
     DateFormatter 객체를 생성하여 리턴
     - parameter identifier: 미입력시 "ko_KR"
     - parameter abbreviation: 미입력시 "KST"
     - parameter format: 미입력시 "yyyy-MM-dd" 기본값
     - returs: 파라미터에 의해 구성된 DateFormatter 객체
     */
    private func createDateFormatter(_ identifier: String = "ko_KR", _ abbreviation: String = "KST",
                                     format: String = "yyyy-MM-dd") -> DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.timeZone = TimeZone(abbreviation: abbreviation)!
        dateFormatter.dateFormat = format
        return dateFormatter
    }
}
