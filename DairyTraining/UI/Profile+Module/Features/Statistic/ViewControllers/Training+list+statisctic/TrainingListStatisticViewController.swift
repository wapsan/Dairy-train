import UIKit

final class TrainingListStatisticViewController: MainTabBarItemVC {
    
    //MARK: - @IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var fadedBottomView: UIView!
    
    
    //MARK: - Properties
    private var viewModel: TrainingListStatisticsViewModelInput
    private var itemSize: CGSize {
        let itemWidth = self.collectionView.bounds.width / 2
        let itemHeight = itemWidth * 1.3
        return CGSize(width: itemWidth, height: itemHeight)
    }
    private lazy var gradient = CAGradientLayer()
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = fadedBottomView.bounds
    }
    
    //MARK: - Initialization
    init(viewModel: TrainingListStatisticsViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private
private extension TrainingListStatisticViewController {
    
    func setup() {
        collectionView.register(DTTrainCell.self,
                                forCellWithReuseIdentifier: DTTrainCell.cellID)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "aa")
    }
    
    func setbottomFadedView() {
        gradient.colors = [UIColor.clear.cgColor, DTColors.backgroundColor.cgColor]
        gradient.locations = [0.0, 1.0]
        fadedBottomView.layer.insertSublayer(gradient, at: 0)
    }
}

//MARK: - UICollectionViewDataSource
extension TrainingListStatisticViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.trainigList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let training = viewModel.trainigList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTTrainCell.cellID, for: indexPath)
        (cell as? DTTrainCell)?.setCellFor(training)
        (cell as? DTTrainCell)?.setGroupIcons(by: training.muscleGroupInCurrentTrain)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension TrainingListStatisticViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.trainigWasSelected(at: indexPath.row)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrainingListStatisticViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "aa", for: indexPath)
        header.frame.size.height = 100
        return header
    }
}
