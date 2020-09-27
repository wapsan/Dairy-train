//import UIKit
//
//class TrainingListStatisticsViewController: TrainingListViewController {
//
//    //MARK: - Properties
////    var viewModel: TrainingListStatisticsViewModelInput?
//    var router: TrainingListStatisticsRouter?
//
//    //MARK: - Properties
//    override var headerTitle: String {
//        get {
//            return LocalizedString.trainingStatistics
//        }
//        set {}
//    }
//
//    //MARK: - GUI Properties
//    private lazy var backBarButtonItem: UIBarButtonItem = {
//        let backBarButtonitem = UIBarButtonItem(title: nil,
//                                                style: .plain,
//                                                target: self,
//                                                action: #selector(self.backButtonPressed))
//        return backBarButtonitem
//    }()
//
//    //MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.viewModel?.loadStatisticsList()
//        self.setUpNavigationItem()
//    }
//
//    //MARK: - Private methods
//    private func setUpNavigationItem() {
//        self.navigationItem.title = LocalizedString.statistics
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.backBarButtonItem = self.backBarButtonItem
//    }
//
//    //MARK: - Actions
//    @objc private func backButtonPressed() {
//        self.navigationController?.popViewController(animated: true)
//    }
//}
//
////MARK: - UICollectionview methods
//extension TrainingListStatisticsViewController {
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let choosenTrain = self.viewModel?.trainigList[indexPath.row] else { return }
//        self.router?.pushTrainingStatisticsViewController(for: choosenTrain)
//    }
//}
