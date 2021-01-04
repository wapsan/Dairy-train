import UIKit

enum HomeMenuItem: CaseIterable {
    case welcome
    case createTrainingFromExerciseList
    case createTrainingFromTrainingPatern
    case createTrainingFromSpecialTraining
    case addMeal
    case mounthlyStatistics
    
    var titel: String {
        switch self {
        case .createTrainingFromExerciseList:
            return "Create training from exiting exercises."
        case .createTrainingFromTrainingPatern:
            return "Cretate training from training patern."
        case .createTrainingFromSpecialTraining:
            return "Create training from sepcial training list challenge."
        case .addMeal:
            return "Add meal to you daily nutrition list."
        case .mounthlyStatistics:
            return "Monthly statistics."
        case .welcome:
            return ""
        }
    }
    
    var image: UIImage? {
        switch self {
        case .createTrainingFromExerciseList:
            return nil
        case .createTrainingFromTrainingPatern:
            return nil
        case .createTrainingFromSpecialTraining:
            return nil
        case .addMeal:
            return nil
        case .mounthlyStatistics:
            return nil
        case .welcome:
            return nil
        }
    }
    
    func onAction() {
        switch self {
        case .createTrainingFromExerciseList:
            MainCoordinator.shared.coordinate(to: MuscleGroupsCoordinator.Target.muscularGrops(patern: .training))
        case .createTrainingFromTrainingPatern:
            MainCoordinator.shared.coordinate(to: TrainingPaternsCoordinator.Target.trainingPaternsList)
        case .createTrainingFromSpecialTraining:
            MainCoordinator.shared.coordinate(to: TrainingProgramsCoordinator.Target.trainingLevels)
        case .addMeal:
            MainCoordinator.shared.coordinate(to: NutritionModuleCoordinator.Target.searchFood)
        case .mounthlyStatistics:
            return
        case .welcome:
            return
        }
    }
}
