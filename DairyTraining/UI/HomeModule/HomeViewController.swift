import UIKit

protocol HomeView: AnyObject {
    
}

final class HomeViewController: UIViewController {
    
    // MARK: - Types
    private enum HomeViewCollectionSection {
        case main
    }
    
    // MARK: - @IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - GUI Properties
    private var stratchabelHeader: StretchableHeader?
    
    // MARK: - Properties
    private let presenter: HomePresenterProtocol
    private var dataSource: UICollectionViewDiffableDataSource<HomeViewCollectionSection, Int>?
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if tabBarController?.tabBar.isHidden ?? false { showTabBar() }
        tabBarController?.view.window?.backgroundColor = .white
    }
    
    // MARK: - Initialization
    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        navigationController?.navigationBar.isHidden = true
        collectionView.register(UINib(nibName: HomeViewCollectionCell.xibName, bundle: nil),
                                forCellWithReuseIdentifier: HomeViewCollectionCell.cellID)
        setupHeaders()
        collectionView.collectionViewLayout = createLayout2()
        configureDataSource()
        
    }
    
    private func setupHeaders() {
        let headerSize = CGSize(width: collectionView.frame.size.width, height: 200)
        stratchabelHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        stratchabelHeader?.title = presenter.title
        stratchabelHeader?.customDescription = presenter.description
        stratchabelHeader?.topRightButtonAction = { [unowned self] in self.presenter.menuButtonPressed() }
        stratchabelHeader?.setTopRightButton(image: UIImage(named: "icon_home_menu"))
        stratchabelHeader?.backgroundColor = .black
        stratchabelHeader?.backButtonImageType = .none
        stratchabelHeader?.minimumContentHeight = 44
        guard let header = stratchabelHeader else { return }
        collectionView.addSubview(header)
    }
    
    func createLayout2() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(0.6)))
            let leadingitem2 = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(0.4)))
            let leadingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingItem, leadingitem2])
            
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.4)))
            let trailingItem2 = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.6)))
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [trailingItem, trailingItem2])
            
            let bottomNestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(600)),
                subitems: [leadingGroup, trailingGroup])

            let buttomItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(200)))
            let nestedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(500)),
                subitems: [bottomNestedGroup, buttomItem])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
            return section
            
        }
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeViewCollectionSection, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCollectionCell.cellID, for: indexPath)
            (cell as? HomeViewCollectionCell)?.setCell(for: self.presenter.menuItem(at: indexPath))
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<HomeViewCollectionSection, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<presenter.menuItemCount))
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - HomeView
extension HomeViewController: HomeView { }

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAtIndex(indexPath)
    }
}
