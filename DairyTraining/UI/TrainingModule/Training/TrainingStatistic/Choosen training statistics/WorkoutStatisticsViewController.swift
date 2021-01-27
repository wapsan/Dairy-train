import UIKit

final class WorkoutStatisticsViewController: BaseViewController {
    
    // MARK: - Module properties
    private var viewModel: WorkoutStatisticsViewModelProtocol
    
    // MARK: - @IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - GUI Properties
    private var stratchabelHeader: StretchableHeader?
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: - Initialization
    init(viewModel: WorkoutStatisticsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension
private extension WorkoutStatisticsViewController {
    
    func setup() {
        collectionView.register(DTStatisticInfoCell.self, forCellWithReuseIdentifier: DTStatisticInfoCell.cellID)
        collectionView.register(DTTrainedSubGroupCell.self, forCellWithReuseIdentifier: DTTrainedSubGroupCell.cellID)
        setupHeaders()
    }
    
    private func setupHeaders() {
        let headerSize = CGSize(width: collectionView.frame.size.width, height: 250)
        stratchabelHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        stratchabelHeader?.title = viewModel.title
        stratchabelHeader?.customDescription = viewModel.description
        stratchabelHeader?.backButtonImageType = .goBack
        stratchabelHeader?.onBackButtonAction = { [unowned self] in self.dismiss(animated: true, completion: nil) }
        stratchabelHeader?.backgroundColor = .black
        stratchabelHeader?.minimumContentHeight = 44
        guard let header = stratchabelHeader else { return }
        collectionView.addSubview(header)
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
extension WorkoutStatisticsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DTStatisticInfoCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTStatisticInfoCell.cellID,
                                                      for: indexPath)
        let traindedSubgroupCell = collectionView.dequeueReusableCell(withReuseIdentifier: DTTrainedSubGroupCell.cellID,
                                                                      for: indexPath)
        let statistics = self.viewModel.statistics
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
extension WorkoutStatisticsViewController: UICollectionViewDelegateFlowLayout {
    
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
