import UIKit

final class TrainingListStatisticsRouter: Router {
    
    //MARK: - Properties
   // private weak var rootViewController: TrainingListStatisticsViewController?
    
    //MARK: - Initialization
    init(_ viewController: UIViewController) {
      //  self.rootViewController = viewController as? TrainingListStatisticsViewController
    }
    
    //MARK: - Public methods
    func pushTrainingStatisticsViewController(for train: TrainingManagedObject) {
        let chooseTrainingStatistics = self.configureTVSModule(for: train)//self.configureTrainingStatisticsViewController(for: train)
      //  self.rootViewController?.navigationController?.pushViewController(chooseTrainingStatistics,
      //                                                                    animated: true)
    }
}

//MARK: - Private extension
private extension TrainingListStatisticsRouter {
    
//    func configureTrainingStatisticsViewController(for train: TrainingManagedObject) -> TrainStatisticsViewController {
//        let traininiStatisticsVC = TrainStatisticsViewController()
//        let trainingStatisticaViewModel = TrainStatisticsViewModel()
//        let trainingStatisticsNodel = TrainStatisticsModel(train: train)
//        traininiStatisticsVC.viewModel = trainingStatisticaViewModel
//        trainingStatisticaViewModel.model = trainingStatisticsNodel
//        trainingStatisticsNodel.output = trainingStatisticaViewModel
//        return traininiStatisticsVC
//    }
    
    
    func configureTVSModule(for train: TrainingManagedObject) -> ChoosenTrainingStatisticsViewController {
        let testSVC = ChoosenTrainingStatisticsViewController()
        let testSVM = ChoosenTrainingStatisticsViewModel()
        let testSM = ChoosenTrainingStatisticsModel(train)
        testSVC.viewModel = testSVM
        testSVM.model = testSM
        testSM.output = testSVM
        return testSVC
    }
}
