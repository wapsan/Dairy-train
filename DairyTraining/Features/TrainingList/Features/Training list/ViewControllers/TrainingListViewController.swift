import UIKit

protocol TraininglistViewControllerIteractin: AnyObject {
    func trainingWasChanged()
    func trainingListWasChanged()
    func setTrashButton(isActive: Bool)
}

final class TrainingListViewController: MainTabBarItemVC {
    
    //MARK: - Module properties
    var viewModel: TrainingListViewModelIteracting?
    
    //MARK: - Private properties
    private lazy var editButtonTitle: String = LocalizedString.edit
    private lazy var doneButtonTitle: String = LocalizedString.done
    private var itemSize: CGSize {
        let itemWidth = self.collectionView.bounds.width / 2
        let itemHeight = itemWidth * 1.3
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    //MARK: - Properties
    override var isEditing: Bool {
        didSet {
            self.editTrainListButton.title = oldValue == true ?
                self.editButtonTitle :
                self.doneButtonTitle
            self.navigationItem.rightBarButtonItem = oldValue == false ?
                self.deleteTrainButton :
            nil
        }
    }
    
    //MARK: - GUI Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DTTrainCell.self,
                                forCellWithReuseIdentifier: DTTrainCell.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var headerView: DTHeaderView = {
        let view = DTHeaderView(title: LocalizedString.trainingListHeader)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyTainingListLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.text = LocalizedString.trainingListIsEmty
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteTrainButton: UIBarButtonItem = {
        let removeTrainingButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                                   target: self,
                                                   action: #selector(self.removeChoosenTrain))
        removeTrainingButton.isEnabled = false
        return removeTrainingButton
    }()
    
    private lazy var editTrainListButton: UIBarButtonItem = {
        let editingButton = UIBarButtonItem(title: LocalizedString.edit,
                                            style: .done,
                                            target: self,
                                            action: #selector(self.editingButtonPressed(_:)))
        return editingButton
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewController()
        self.setUpEditingButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isEditing {
            self.isEditing = false
        }
    }
}

//MARK: - Private extension
private extension TrainingListViewController {
    
    func setUpEditingButton() {
        self.navigationItem.leftBarButtonItem = self.editTrainListButton
    }
    
    func setUpViewController() {
        guard let isTrainiingEmty = self.viewModel?.isTrainingEmty else { return }
        if isTrainiingEmty {
            self.setUpEmptyTrainingList()
            self.deactivateNotEmptyTrainingListConstraints()
            self.headerView.removeFromSuperview()
            self.collectionView.removeFromSuperview()
        } else {
            self.setHeaderView()
            self.setUpCollectionView()
            self.deactivateEmtyTrainingListLabelConstraints()
            self.emptyTainingListLabel.removeFromSuperview()
            self.collectionView.reloadData()
        }
    }
    
    func setHeaderView() {
        self.view.addSubview(self.headerView)
        self.setUpConstrains()
    }
    
    func setUpCollectionView() {
        self.view.addSubview(self.collectionView)
        self.setCollectionViewConstraint()
    }
    
    func setUpEmptyTrainingList() {
        self.view.addSubview(self.emptyTainingListLabel)
        self.setUpEmtyTrainingListLabelConstraints()
    }
    
    func deselectSelectedItem() {
        guard let indexPaths = self.collectionView.indexPathsForSelectedItems else { return }
        for indexPath in indexPaths {
            if let cell = self.collectionView.cellForItem(at: indexPath) as? DTTrainCell {
                cell.setDeselectedBackground()
                self.collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    
    func deleteChoosenTrain() {
        self.deselectSelectedItem()
        self.setUpViewController()
    }
    
    func showDeletingTrainAlert() {
        AlertHelper.shared.showDefaultAlert(
            on: self,
            title: LocalizedString.deleltingTrainAlertTitle,
            message: LocalizedString.deleltingTrainAlertMessage,
            cancelTitle: LocalizedString.cancel,
            okTitle: LocalizedString.ok,
            style: .alert,
            completion: { [weak self] in
                guard let self = self else { return }
                self.viewModel?.deleteChoosenTraining()
                NotificationCenter.default.post(name: .trainingListWasChanged,
                                                object: nil)
                self.showDeletedTrainAlert()
        })
    }
    
    func showDeletedTrainAlert() {
        AlertHelper.shared.showDefaultAlert(
            on: self,
            title: LocalizedString.deletedTrainAlertTitle,
            message: "",
            cancelTitle: nil,
            okTitle: LocalizedString.ok,
            style: .alert,
            completion: nil)
    }
    
    //MARK: - Constraint
    func setUpConstrains() {
        let safeAre = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: safeAre.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: safeAre.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: safeAre.trailingAnchor)
        ])
    }
    
    func setCollectionViewConstraint() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor,
                                                     constant: DTEdgeInsets.small.top),
            self.collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
        ])
    }
    
    func deactivateNotEmptyTrainingListConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.deactivate([
            self.collectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor,
                                                     constant: DTEdgeInsets.small.top),
            self.collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
        ])
        
        NSLayoutConstraint.deactivate([
            self.headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    func setUpEmtyTrainingListLabelConstraints() {
        NSLayoutConstraint.activate([
            self.emptyTainingListLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emptyTainingListLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    func deactivateEmtyTrainingListLabelConstraints() {
        NSLayoutConstraint.deactivate([
            self.emptyTainingListLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emptyTainingListLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    //MARK: - Actions
    @objc  func editingButtonPressed(_ sender: UIBarButtonItem) {
        if self.isEditing {
            self.deselectSelectedItem()
            self.isEditing = false
        } else {
            self.isEditing = true
            self.setUpViewController()
        }
    }
    
    @objc  func removeChoosenTrain() {
        self.showDeletingTrainAlert()
    }
}

//MARK: - CollectionView Extension
extension TrainingListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.trainingCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTTrainCell.cellID,
                                                      for: indexPath)
        guard let train = self.viewModel?.getTraining(for: indexPath.row) else {
            return UICollectionViewCell()
        }
        (cell as? DTTrainCell)?.setDeselectedBackground()
        (cell as? DTTrainCell)?.setCellFor(train)
        (cell as? DTTrainCell)?.setGroupIcons(by: train.muscleGroupInCurrentTrain)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isEditing {
            self.viewModel?.trainingWasSelected(at: indexPath.row)
            if let cell = collectionView.cellForItem(at: indexPath) as? DTTrainCell {
                cell.setSelectedBackground()
            }
        } else {
            self.viewModel?.goToTraining(at: indexPath.row)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if self.isEditing {
            self.viewModel?.trainingWasDeselected(at: indexPath.row)
            if let cell = collectionView.cellForItem(at: indexPath) as? DTTrainCell {
                cell.setDeselectedBackground()
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.collectionView.allowsMultipleSelection = true
    }
}

//MARK: - TraininglistViewControllerIteractin
extension TrainingListViewController: TraininglistViewControllerIteractin {
    
    func trainingWasChanged() {
        let curentTrainingIndexPath = IndexPath(row: 0, section: 0)
        self.collectionView.reloadItems(at: [curentTrainingIndexPath])
    }
    
    func trainingListWasChanged() {
        self.setUpViewController()
    }
    
    func setTrashButton(isActive: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = isActive
    }
}
