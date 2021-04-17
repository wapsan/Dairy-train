import Foundation


struct MeasurementUnit {
    
    struct Weight: Codable {
        
        private let _value: Float
        private let weightMode: UserInfo.WeightMode
        
        var value: Float {
            let systemWeightMode = UserDefaults.standard.weightMode
            if systemWeightMode == weightMode {
                return _value.cutFloatingValue
            } else {
                return (_value * weightMode.multiplier).cutFloatingValue
            }
        }
        
        
        init(weightValue: Float, weightMode: UserInfo.WeightMode) {
            self._value = weightValue
            self.weightMode = weightMode
        }
        
    }
    
    struct Height: Codable {
        
        //MARK: - Private properites
        private let _value: Float
        private let heightMode: UserInfo.HeightMode
        
        //MARK: - Properies
        var value: Float {
            let systemHeightMode = UserDefaults.standard.heightMode
            if systemHeightMode == heightMode {
                return _value.cutFloatingValue
            } else {
                return (_value * heightMode.multiplier).cutFloatingValue
            }
        }
        
        //MARK: - Initialization
        init(heightValue: Float, heightMode: UserInfo.HeightMode) {
            self._value = heightValue
            self.heightMode = heightMode
        }
    }
}
