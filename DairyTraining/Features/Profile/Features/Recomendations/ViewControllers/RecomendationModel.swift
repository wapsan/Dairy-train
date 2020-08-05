import Foundation

protocol RecomendationModelOutput: AnyObject {
    func setRecomendationInfo(to info: [RecomendationInfo])
}

protocol RecomendationModelIteracting: AnyObject {
    func calculateRecomendation()
}

final class RecomendationModel {
    weak var ouptup: RecomendationModelOutput?
}

extension RecomendationModel: RecomendationModelIteracting {
    func calculateRecomendation() {
        guard let mainInfo = CoreDataManager.shared.readUserMainInfo(),
        let mainInfoCodableModel = UserMainInfoCodableModel(from: mainInfo) else { return }
        let recomendationInfo  = CaloriesCalculator.shared.getUserParameters(from: mainInfoCodableModel)
        self.ouptup?.setRecomendationInfo(to: recomendationInfo)
    }
}
