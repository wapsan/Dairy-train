import Foundation

protocol RecomendationViewModelInput  {
    func calculateRecomendation()
    var supplyModel: [RecomendationInfo] { get set }
}

final class RecomendationViewModel {
    
    var model: RecomendationModelIteracting?
    private var _supplyModel: [RecomendationInfo] = []
}

//MARK: - RecomendationModelOutput
extension RecomendationViewModel: RecomendationModelOutput {
    
    func setRecomendationInfo(to info: [RecomendationInfo]) {
        self.supplyModel = info
    }
}

//MARK: - RecomendationViewModelInput
extension RecomendationViewModel: RecomendationViewModelInput {
    
    var supplyModel: [RecomendationInfo] {
        get {
            return self._supplyModel
        }
        set {
            self._supplyModel = newValue
        }
    }
    
    func calculateRecomendation() {
        self.model?.calculateRecomendation()
    }
}
