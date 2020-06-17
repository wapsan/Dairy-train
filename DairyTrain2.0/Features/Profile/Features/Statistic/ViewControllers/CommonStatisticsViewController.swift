import UIKit

class CommonStatisticsViewController: TrainingListVC {
    
    //MARK: - Private properties
    private lazy var trains = UserModel.shared.trains
    
    //MARK: - Properties
    override var headerTitle: String {
        get {
            return LocalizedString.trainingStatistics
        }
        set {}
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LocalizedString.statistics
    }
    
    //MARK: - Private methods
    private func pushStatisticsViewController(for train: Train) {
        let trainStatiticsViewController = TrainStatisticsViewController()
        trainStatiticsViewController.setTrain(to: train)
        self.navigationController?.pushViewController(trainStatiticsViewController, animated: true)
    }
}

//MARK: - UICollectionview methods
extension CommonStatisticsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let choosenTrain = self.trains[indexPath.row]
        self.pushStatisticsViewController(for: choosenTrain)
    }
}




