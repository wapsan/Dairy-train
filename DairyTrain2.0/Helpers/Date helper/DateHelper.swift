import Foundation


class DateHelper {
    
    //MARK: - Private properties
    private var _date  = Date()
    private var _dateFormat = "dd/MM/yyyy"
    private var dateFormater = DateFormatter()
    
    //MARK: - Properties
    static var shared = DateHelper()
    
    var currnetDate: String {
        dateFormater.dateFormat = _dateFormat
        return dateFormater.string(from: _date)
    }
    
}
