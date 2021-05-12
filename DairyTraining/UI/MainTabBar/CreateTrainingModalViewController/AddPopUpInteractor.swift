import UIKit

protocol AddPopUpInteractorProtocol {
    
    var options: [AddPopUpInteractor.Option] { get }
    
}

final class AddPopUpInteractor {
    
    private let optionType: AddingOptionType
    
    private lazy var workoutsOptions: [AddPopUpInteractor.Option] = [.fromExerciseList,
                                                                     .fromTrainingPatern,
                                                                     .fromSpecialTraining]
    
    private lazy var nutritionOptions: [AddPopUpInteractor.Option] = [.searchFood,
                                                                      .customFood]
    
    init(optionType: AddingOptionType) {
        self.optionType = optionType
    }
 
}

extension AddPopUpInteractor: AddPopUpInteractorProtocol {
    
    var options: [Option] {
        optionType == .mealEntity ? nutritionOptions : workoutsOptions
    }
}
