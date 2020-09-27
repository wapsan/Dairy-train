import UIKit

final class ChoosenTrainingStatisticsViewController: MainTabBarItemVC {
    
    //MARK: - Properties
    var viewModel: ChoosenTrainingStatisticsViewModel?
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    //MARK: - GUI Properties
    private var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.collectionLayout)
        collectionView.register(DTStatisticInfoCell.self,
                                forCellWithReuseIdentifier: DTStatisticInfoCell.cellID)
        collectionView.register(DTTrainedSubGroupCell.self,
                                forCellWithReuseIdentifier: DTTrainedSubGroupCell.cellID)
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        self.viewModel?.loadStatistics()
        self.navigationItem.title = self.viewModel?.statistic?.trainingDate
    }
    
    
}

//MARK: - Private extension
private extension ChoosenTrainingStatisticsViewController {
    
    func setUpCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.safeArea.topAnchor,
                                                     constant: DTEdgeInsets.small.top),
            self.collectionView.leftAnchor.constraint(equalTo: self.safeArea.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.safeArea.rightAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor,
                                                        constant: DTEdgeInsets.small.bottom)
        ])
    }
    
    func setItemSize(for index: Int) -> CGSize {
        switch index {
        case 0, 1:
            let height = self.collectionView.bounds.height / 4
            let width = self.collectionView.bounds.width / 2
            let itemSize = CGSize(width: width, height: height)
            return itemSize
        case 2, 3, 4:
            let height = self.collectionView.bounds.height / 4
            let width = self.collectionView.bounds.width
            let itemSize = CGSize(width: width, height: height)
            return itemSize
        default:
            return .zero
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ChoosenTrainingStatisticsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DTStatisticInfoCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTStatisticInfoCell.cellID,
                                                      for: indexPath)
        let traindedSubgroupCell = collectionView.dequeueReusableCell(withReuseIdentifier: DTTrainedSubGroupCell.cellID,
                                                                      for: indexPath)
        guard let statistics = self.viewModel?.statistic else { return UICollectionViewCell() }
        guard let cellType = DTStatisticInfoCellType.init(rawValue: indexPath.row) else { return UICollectionViewCell()}
        
        switch cellType {
        case .trainedSubgroup:
            (traindedSubgroupCell as? DTTrainedSubGroupCell)?.renderCell(for: statistics)
            return traindedSubgroupCell
        default:
            (cell as? DTStatisticInfoCell)?.renderCell(for: cellType, and: statistics)
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ChoosenTrainingStatisticsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.setItemSize(for: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
