import UIKit

class CommonStatisticsViewController: TrainingListViewController {
    
    //MARK: - Private properties
    private lazy var trains = CoreDataManager.shared.fetchTrainingList()
    
    //MARK: - Properties
    override var headerTitle: String {
        get {
            return LocalizedString.trainingStatistics
        }
        set {}
    }
    
    //MARK: - GUI Properties
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let backBarButtonitem = UIBarButtonItem(title: nil,
                                                style: .plain,
                                                target: self,
                                                action: #selector(self.backButtonPressed))
        return backBarButtonitem
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationItem()
    }
    
    //MARK: - Private methods
    private func setUpNavigationItem() {
        self.navigationItem.title = LocalizedString.statistics
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.backBarButtonItem = self.backBarButtonItem
    }
    
    private func pushStatisticsViewController(for train: TrainingManagedObject) {
        let trainStatiticsViewController = TrainStatisticsViewController()
        trainStatiticsViewController.setTrain(to: train)
        self.navigationController?.pushViewController(trainStatiticsViewController, animated: true)
    }
    
    //MARK: - Actions
    @objc private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionview methods
extension CommonStatisticsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let choosenTrain = self.trains[indexPath.row]
        self.pushStatisticsViewController(for: choosenTrain)
    }
}
