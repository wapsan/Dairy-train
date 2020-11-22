import Foundation

final class DateHelper {
    
    // MARK: - Types
    enum DateFormatTypes: String {
        case trainingDateFromat = "dd/MM/yyyy"
        case synhronizationDateFromat = "MM-dd-yyyy HH:mm"
        case dateForStatisticsFromat = "dd.MM"
    }
    
    //MARK: - Static properties
    static var shared = DateHelper()
    
    //MARK: - Private properties
    private lazy var dateFormater = DateFormatter()
    
    //MARK: - Computed properties
    var currnetDate: String {
        dateFormater.dateFormat = DateFormatTypes.trainingDateFromat.rawValue
        return dateFormater.string(from: Date())
    }
    
    var currentDateForSynhronize: String {
        dateFormater.dateFormat = DateFormatTypes.synhronizationDateFromat.rawValue
        return dateFormater.string(from: Date())
    }
    
    //MARK: - Initialization
    private init () {}
    
    //MARK: - Public methods
    func getFormatedDateFrom(_ date: Date, with format: DateFormatTypes) -> String {
        dateFormater.dateFormat = format.rawValue
        return dateFormater.string(from: date)
    }
    
    private func getFormatedDateFrom(_ date: Date) -> String {
        return dateFormater.string(from: date)
    }
}
