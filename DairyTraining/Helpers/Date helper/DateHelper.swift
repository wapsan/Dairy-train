import Foundation

class DateHelper {
    
    //MARK: - Static properties
    static var shared = DateHelper()
    
    //MARK: - Private properties
    private lazy var standartDateFormat = "dd/MM/yyyy"
    private lazy var dateFormatForSynhronization = "MM-dd-yyyy HH:mm"
    private lazy var dateFormater = DateFormatter()
    
    //MARK: - Computed properties
    var currnetDate: String {
        self.dateFormater.dateFormat = standartDateFormat
        return self.dateFormater.string(from: Date())
    }
    
    var currentDateForSynhronize: String {
        self.dateFormater.dateFormat = dateFormatForSynhronization
        return self.dateFormater.string(from: Date())
    }
    
    //MARK: - Initialization
    private init () { }
    
    //MARK: - Public methods
    func getFormatedDateFrom(_ date: Date) -> String {
        return self.dateFormater.string(from: date)
    }
}
