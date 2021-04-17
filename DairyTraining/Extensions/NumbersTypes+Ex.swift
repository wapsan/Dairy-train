import Foundation

//MARK: - Float
extension Float {
    
    func asPercents() -> Float {
        return self / 100
    }
    
    var string: String {
        return String(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var cutFloatingValue: Float {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return self.rounded()
        } else {
            return self.rounded(toPlaces: 2)
        }
        
        
    }
    
    private func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

//MARK: - Int64
extension Int64 {
    
    var float: Float {
        return Float(self)
    }
    
    var int: Int {
        return Int(self)
    }
    
    var string: String {
        return String(self)
    }
    
    var double: Double {
        return Double(self)
    }
}

//MARK: - Double
extension Double {
    
    var float: Float {
        return Float(self)
    }
}

//MARK: - Int
extension Int {
    
    var float: Float {
        Float(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var int64: Int64 {
        return Int64(self)
    }
}
