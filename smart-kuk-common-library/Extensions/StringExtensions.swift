
import Foundation

extension String {
    
    /**
     문자열에서 숫자만으로 문자열로 다시 생성한 뒤에 리턴
     - returns: 변환된 배열
     */
    func extractNumber() -> String {
        
        //결과물이 되는 문자열 변수
        var haveOnlyNumber: String = ""
        
        //숫자를 판단하기 위한 문자셋 중의 숫자
        let set = CharacterSet.decimalDigits
        
        //현재 문자열의 요소를 unicodeScalars 형태로 뽑아서 숫자 set에 포함된 요소인지 검사하고 포함 되었다면 리턴할 변수에 append
        for ch in self.unicodeScalars {
            if set.contains(ch) {
                haveOnlyNumber.append(String(ch))
            }
        }
        return haveOnlyNumber
    }
    
    /**
     문자열에서 숫자만을 추출하여 파라미터로 넘긴 포맷에 의해 변환하여 리턴 주의할 점은 숫자로만 이루어진 문자열을 숫자로 변환시 왼쪽 끝의 0이 있으면 사라질수 있다.
     - parameter format: 숫자 포맷
     - returns: 변환된 배열(만약 숫자로만 구성된 문자열을 숫자로 변경 못하거나, 숫자를 포맷으로 변환을 못하면 기존의 문자열을 그대로 리턴)
     */
    func extractNumber(byFormat format: NumberFormatter.Style) -> String {
        
        //String.extractNumber() 사용한 결과 문자열을 숫자로 변경할 포맷
        let decimal = NumberFormatter()
        decimal.numberStyle = NumberFormatter.Style.decimal
        
        //사용자의 파라미터로 받은 스타일을 적용할 포맷
        let numFormat = NumberFormatter()
        numFormat.numberStyle = format
        
        //문자열에서 숫자만을 뽑아서 문자열로 받아옴
        let onlyNumber = self.extractNumber()
        if let realNumber = decimal.number(from: onlyNumber) {
            if let formattedNumberString = numFormat.string(from: realNumber) {
                return formattedNumberString
            }
        }
        
        //위에 처리가 실패하면 기존 자기 자신을 리턴
        return self
    }
    
    fileprivate var skipTable: [Character: Int] {
        var skipTable: [Character: Int] = [:]
        for (i, c) in enumerated() {
            skipTable[c] = count - i - 1
        }
        return skipTable
    }
    
    fileprivate func match(from currentIndex: Index, with pattern: String) -> Index? {
        // 1
        if currentIndex < startIndex { return nil }
        if currentIndex >= endIndex { return nil }
        
        // 2
        if self[currentIndex] != pattern.last { return nil }
        
        // 3
        if pattern.count == 1 && self[currentIndex] == pattern.last { return currentIndex }
        return match(from: index(before: currentIndex), with: "\(pattern.dropLast())")
    }
    
    func index(of pattern: String) -> Index? {
        // 1
        let patternLength = pattern.count
        guard patternLength > 0, patternLength <= count else { return nil }
        
        // 2
        let skipTable = pattern.skipTable
        let lastChar = pattern.last!
        
        // 3
        var i = index(startIndex, offsetBy: patternLength - 1)
        
        while i < endIndex {
            let c = self[i]
            
            // 2
            if c == lastChar {
                if let k = match(from: i, with: pattern) { return k }
                i = index(after: i)
            } else {
                // 3
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        
        return nil
    }
    
    /**
     문자열이 숫자로만 구성되었는지 검사하고 참 거짓 리턴
     - returns : true 이면 Int 변환이 성공한 것이므로 숫자
     */
    func haveAllDigits() -> Bool {
        if Int(self) != nil {
            return true
        }
        return false
    }
    
    /**
     self 문자열을 사용하여 Date 객체로 변환
     - returns: 옵션널 Date 객체
     */
    func date() -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_KR")
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.date(from: self)
    }
    
    func decimal() -> String {
        let numFormat = NumberFormatter()
        numFormat.numberStyle = NumberFormatter.Style.decimal
        if let toBeConverted = numFormat.number(from: self) {
            if let convertedStr = numFormat.string(from: toBeConverted) {
                return convertedStr
            }
        }
        return self
    }
    
    /**
     문자열이 비어 있지 않으면 구분자를 추가
     - parameter delimeter: 구분자가 될 문자열(기본값은 스페이스)
     - returns: 문자열
     */
    public func notEmptyAppend(_ delimeter: String = " ") -> String {
        var new: String!
        if !self.isEmpty || self != "" {
            new = delimeter + self
        } else {
            new = self
        }
        
        return new
    }
}

