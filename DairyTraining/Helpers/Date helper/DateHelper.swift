import Foundation

class DateHelper {
    
    // MARK: - Types
    enum DateFormatTypes: String {
        case trainingDateFromat = "dd/MM/yyyy"
        case synhronizationDateFromat = "MM-dd-yyyy HH:mm"
        case dateForStatisticsFromat = "dd.MM"
    }
    
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
    private init () {
        dateFormater.dateFormat = standartDateFormat
    }
    
    //MARK: - Public methods
    func getFormatedDateFrom(_ date: Date, with format: DateFormatTypes) -> String {
        dateFormater.dateFormat = format.rawValue
        return dateFormater.string(from: date)
    }
    
    func getFormatedDateFrom(_ date: Date) -> String {
        return self.dateFormater.string(from: date)
    }
}
