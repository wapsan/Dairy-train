import Foundation

class DateHelper {
    
    //MARK: - Static properties
    static var shared = DateHelper()
    
    //MARK: - Private properties
    private var date  = Date()
    private var dateFormat = "dd/MM/yyyy"
    private var dateFormater = DateFormatter()
    
    //MARK: - Computed properties
    var currnetDate: String {
        dateFormater.dateFormat = dateFormat
        return dateFormater.string(from: date)
    }
    
    //MARK: - Initialization
    private init () {
        
    }
}
