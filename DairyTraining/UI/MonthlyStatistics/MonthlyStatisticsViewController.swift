import UIKit

protocol MonthlyStatisticsViewProtocol: AnyObject {
    
}

class MonthlyStatisticsViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet private var collectionView: UICollectionView?
    
    //MARK: - GUI Properties
    private var stratchabelHeader: StretchableHeader?
    
    //MARK: - Private properties
    private let viewModel: MonthlyStatisticsViewModelProtocol
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Initialization
    init(viewModel: MonthlyStatisticsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    func setup() {
        collectionView?.register(cell: MonthlyStatisticsItemCell.self)
        setupStretchableHeader()
    }
    
    private func setupStretchableHeader() {
        guard let collectionView = self.collectionView else { return }
        let headerSize = CGSize(width: collectionView.frame.size.width, height: 200)
        stratchabelHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        stratchabelHeader?.title = viewModel.title
        stratchabelHeader?.backButtonImageType = .goBack
        stratchabelHeader?.onBackButtonAction = { [unowned self] in
            self.viewModel.backButtonPressed()
        }
        stratchabelHeader?.customDescription = viewModel.description
        stratchabelHeader?.backgroundColor = .black
        stratchabelHeader?.minimumContentHeight = 44
        guard let header = stratchabelHeader else { return }
        collectionView.addSubview(header)
    }
    
}

//MARK: - UICollectionViewDataSource
extension MonthlyStatisticsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyStatisticsItemCell.cellID,
                                                      for: indexPath)
        let statisticEntity = viewModel.item(at: indexPath)
        (cell as? MonthlyStatisticsItemCell)?.configure(for: statisticEntity, indexPath: indexPath)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MonthlyStatisticsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let withd = collectionView.bounds.width / 2
        let height = withd * 1
        return .init(width: withd, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - MonthlyStatisticsViewProtocol
extension MonthlyStatisticsViewController: MonthlyStatisticsViewProtocol {
    
}
