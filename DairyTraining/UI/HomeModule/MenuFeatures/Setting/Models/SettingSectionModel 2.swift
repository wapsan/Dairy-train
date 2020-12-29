import Foundation

class SettingSectionModel {
    
    //MARK: - Enums
    enum SettingSectionType {
        case metrics
        case style
        case synchronization
    }
    
    //MARK: - Properties
    var type: SettingSectionType
    var tittle: String
    var settings: [SettingModel]
    
    //MARK: - Initialization
    init(type: SettingSectionType) {
        self.type = type
        switch type {
        case .metrics:
            self.tittle = LocalizedString.metric
            self.settings = [SettingModel(for: .weightMetric),
                             SettingModel(for: .heightMetric)]
        case .style:
            self.tittle = LocalizedString.style
            self.settings = [SettingModel(for: .colorTheme)]
        case .synchronization:
            self.tittle = LocalizedString.cloydSynhronization
            self.settings = [SettingModel(for: .synchronization)]
        }
    }
}
