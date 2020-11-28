import UIKit
import SideMenu

class ProfileViewController: DTBackgroundedViewController {
 
    //MARK: - Private properties
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private lazy var valueAlert = DTValueAlert()
    private lazy var selectionListAlert = DTSelectionListAlert()
    
    private var itemSize: CGSize {
        let height = self.collectionView.bounds.height / 3
        let width = self.collectionView.bounds.width / 2
        let itemSize = CGSize(width: width, height: height)
        return itemSize
    }
    
    //MARK: - properties
    var viewModel: ProfileViewModel?
    var router: ProfileRouter?
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        extendedLayoutIncludesOpaqueBars = false
        MainCoordinator.shared.setTabBarHidden(false, duration: 0.25)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        self.setUpMenuButtonBar()
        self.valueAlert.delegate = self.viewModel
        self.selectionListAlert.delegate = self.viewModel
        self.view.backgroundColor = DTColors.backgroundColor
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        extendedLayoutIncludesOpaqueBars = true
//    }
}

//MARK: - Private extension
private extension ProfileViewController {
    
    @objc func menuButtonPressed() {
        MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.sideMenu)
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
extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selectRow(at: indexPath.row)
    }
}

//MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileInfoCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTMainInfoCell.cellID,
                                                      for: indexPath)
        (cell as? DTMainInfoCell)?.renderCell(for: indexPath.row)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - TestPVCPresenter
extension ProfileViewController: ProfileViewModelPresenter {
    
    func trainingCountWasChanged(to count: Int) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DTMainInfoCell else { return }
        cell.valueLabel.text = String(count)
    }
    
    func showSelectionlistAlert(for selectedIndex: Int, and value: String?) {
        self.selectionListAlert.present(on: self, for: selectedIndex, and: value)
    }
    
    func hideSelectionListAlert() {
        self.selectionListAlert.hideAlert()
    }
    
    func showValueAlert(for selectedIndex: Int, and value: String?) {
        self.valueAlert.present(on: self, for: selectedIndex, and: value)
    }
    
    func hideValueAlert() {
        self.valueAlert.hideAlert()
    }
    
    func showRecomendationAlert() {
        self.showDefaultAlert(title: LocalizedString.alertError,
        message: LocalizedString.fillInDataErrorMessage,
        preffedStyle: .alert,
        okTitle: LocalizedString.ok)
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
    
    func showErrorSignOutAlert(with error: Error) {
         self.showDefaultAlert(title: LocalizedString.alertError,
                                     message: error.localizedDescription,
                                     preffedStyle: .alert,
                                     okTitle: LocalizedString.ok)
    }
    
    func showMenu() {
        self.router?.showMenuController()
    }
    
    func presentLoginViewController() {
        self.router?.presentLoginViewController()
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
    
    func updatValueInCell(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = self.collectionView.cellForItem(at: indexPath) as? DTMainInfoCell {
            cell.renderCell(for: index)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}

