
import UIKit

class CommonStatisticsVC: TrainsVC {
    
    //MARK: - Private properties
    private lazy var trains = UserModel.shared.trains
    
    //MARK: - Properties
    override var headerTitle: String {
        get {
            return "Training statistics"
        }
        set {}
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Statistics"
    }
    
    //MARK: - Private methods
    private func pushStatisticsViewController(for train: Train) {
        let trainStatiticsViewController = TrainStatisticsVC()
        trainStatiticsViewController.setTrain(to: train)
        self.navigationController?.pushViewController(trainStatiticsViewController, animated: true)
    }
}


//MARK: - UICollectionview datasourse and delegate
extension CommonStatisticsVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let choosenTrain = self.trains[indexPath.row]
        self.pushStatisticsViewController(for: choosenTrain)
    }
}




