import UIKit

class TestPVC: DTBackgroundedViewController {
 
    //MARK: - Private properties
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private lazy var valueAlert = DTValueAlert()
    
    //MARK: - properties
    var viewModel: TestPVM?
    var router: TestPR?
    
    //MARK: - GUI Properties
    private var collactionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.collactionLayout)
        collectionView.register(DTMainInfoCell.self,
                                forCellWithReuseIdentifier: DTMainInfoCell.cellID)
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
        self.setUpMenuButtonBar()
        self.valueAlert.delegate = self.viewModel
        self.view.backgroundColor = DTColors.backgroundColor
    }
}

//MARK: - Private extension
private extension TestPVC {
    
    @objc func menuButtonPressed() {
        self.viewModel?.showMenu()
    }
    
    func setUpMenuButtonBar() {
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.menuButtonPressed))
        self.navigationItem.rightBarButtonItem = menuButton
    }
    
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
}

//MARK: - UICollectionViewDelegate
extension TestPVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selectRow(at: indexPath.row)
    }
}

//MARK: - UICollectionViewDataSource
extension TestPVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainInfoCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTMainInfoCell.cellID,
                                                      for: indexPath)
        (cell as? DTMainInfoCell)?.renderCell(for: indexPath.row)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TestPVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (self.collectionView.bounds.height / 3)
        let width = (self.collectionView.bounds.width / 2)
        let itemSize = CGSize(width: width, height: height)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - TestPVCPresenter
extension TestPVC: TestPVCPresenter {
    
    func showRecomendationAlert() {
        self.showDefaultAlert(title: LocalizedString.alertError,
        message: LocalizedString.fillInDataErrorMessage,
        preffedStyle: .alert,
        okTitle: LocalizedString.ok)
    }
    
    func showMenu() {
        self.router?.showMenuController()
    }
    
    func showSignOutAlert() {
        self.showDefaultAlert(
            title: LocalizedString.signOutAlert,
            message: LocalizedString.signOutAlerMessage,
            preffedStyle: .actionSheet,
            okTitle: LocalizedString.ok,
            cancelTitle: LocalizedString.cancel,
            completion: { [weak self] in
                guard let self = self else { return }
                self.viewModel?.signOut()
        })
    }
    
    func presentLoginViewController() {
        self.router?.presentLoginViewController()
    }
    
    func showErrorSignOutAlert(with error: Error) {
         self.showDefaultAlert(title: LocalizedString.alertError,
                                     message: error.localizedDescription,
                                     preffedStyle: .alert,
                                     okTitle: LocalizedString.ok)
    }
    
    func pushViewControllerFromMenu(_ viewController: UIViewController) {
        self.router?.pushViewControllerFromMenu(viewController)
    }
    
    func updateHeightMode(for cellAtIndex: Int) {
        let indexPath = IndexPath(row: cellAtIndex, section: 0)
        if let cell = self.collectionView.cellForItem(at: indexPath) as? DTMainInfoCell {
            cell.upDateHeightMode()
        }
    }
    
    func updateWeightMode(for cellAtIndex: Int) {
        let indexPath = IndexPath(row: cellAtIndex, section: 0)
        if let cell = self.collectionView.cellForItem(at: indexPath) as? DTMainInfoCell {
            cell.updateWeightMode()
        }
    }
    
    func showValueAlert(for selectedIndex: Int, and value: String?) {
        self.valueAlert.present(on: self, for: selectedIndex, and: value)
    }
    
    func hideaAlert() {
        self.valueAlert.hideAlert()
    }
    
    func updatCell(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = self.collectionView.cellForItem(at: indexPath) as? DTMainInfoCell {
            cell.renderCell(for: index)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension TestPVC: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return MenuPresentationViewController(presentedViewController: presented,
                                              presenting: presenting)
    }
}
