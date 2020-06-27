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
        self.dateFormater.dateFormat = dateFormat
        return self.dateFormater.string(from: self.date)
    }
    
    //MARK: - Initialization
    private init () {
        
    }
    
    //MARK: - Public methods
    func getFormatedDateFrom(_ date: Date) -> String {
        return self.dateFormater.string(from: date)
    }
}
