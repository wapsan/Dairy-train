import UIKit

class TrainingListViewController: MainTabBarItemVC {
    
    //MARK: - Private properties
    private lazy var isTrainingChanged: Bool = false
    private lazy var trainList: [TrainingManagedObject] = []
    private lazy var trainingForDeleting: [Int: TrainingManagedObject] = [:]
    
    private var trainingListForDeleting: [TrainingManagedObject] {
        return self.trainingForDeleting.values.map({ $0 })
    }
    
    //MARK: - Properties
    override var isEditing: Bool {
        didSet {
            self.navigationItem.rightBarButtonItem = oldValue == false ? self.deleteTrainButton : nil
        }
    }
    
    //MARK: - Properties
    lazy var headerTitle = "Your trains"
    
    //MARK: - GUI Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DTTrainCell.self,
                                forCellWithReuseIdentifier: DTTrainCell.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
   private lazy var headerView: DTHeaderView = {
        let view = DTHeaderView(title: self.headerTitle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyTainingListLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.text = "No training yet"
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
        let editingButton = UIBarButtonItem(title: "Edit",
                                            style: .done,
                                            target: self,
                                            action: #selector(self.editingButtonPressed(_:)))
        return editingButton
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObserverForAddTrainToList()
        self.setUpViewController()
        self.setUpTrainList()
        self.setUpEditingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isTrainingChanged {
            self.setUpViewController()
            self.isTrainingChanged = false
        }
    }
    
    //MARK: - Setter
    func setFor(_ traininglist: [TrainingManagedObject]) {
        self.trainList = traininglist
    }
    
    //MARK: - Private methods
    private func setUpTrainList() {
        self.trainList = CoreDataManager.shared.fetchTrainingList()
    }
    
    private func setUpEditingButton() {
        self.navigationItem.leftBarButtonItem = self.editTrainListButton
    }
    
    private func setUpViewController() {
        self.trainList = CoreDataManager.shared.fetchTrainingList()
        if self.trainList.isEmpty {
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
    
    private func setHeaderView() {
        self.view.addSubview(self.headerView)
        self.setUpConstrains()
    }
    
    private func setUpCollectionView() {
        self.view.addSubview(self.collectionView)
        self.setCollectionViewConstraint()
    }
    
    private func setUpEmptyTrainingList() {
        self.view.addSubview(self.emptyTainingListLabel)
        self.setUpEmtyTrainingListLabelConstraints()
    }
    
    private func pushTrainViewController(with trainIndex: Int) {
        let training = self.trainList[trainIndex]
        let trainViewController = TrainingViewController()
        trainViewController.setTraining(training)
        trainViewController.headerTittle = training.formatedDate ?? "0"
        self.navigationController?.pushViewController(trainViewController, animated: true)
    }
    
    private func setTrashButttonState() {
        if !self.trainingForDeleting.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    private func addObserverForAddTrainToList() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingWasAdded),
                                               name: .addNewTrain,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingWasAdded),
                                               name: .trainingWasChanged,
                                               object: nil)
    }
    
    private func deselectSelectedItem() {
        guard let indexPaths = self.collectionView.indexPathsForSelectedItems else { return }
        for indexPath in indexPaths {
            if let cell = self.collectionView.cellForItem(at: indexPath) as? DTTrainCell {
                cell.setBackgroundColorTo(.viewFlipsideBckgoundColor)
                self.collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    
    private func deleteChoosenTrain() {
        self.deselectSelectedItem()
        CoreDataManager.shared.removeTraining(self.trainingListForDeleting)
        self.trainingForDeleting.removeAll()
        self.setTrashButttonState()
        self.setUpViewController()
    }
    
    private func showDeletingTrainAlert() {
        AlertHelper.shared.showDefaultAlert(
            on: self,
            title: "Are you shure?",
            message: "Delete choosen trainings?",
            cancelTitle: "Cancel",
            okTitle: "Ok",
            style: .alert,
            completion: { [weak self] in
                guard let self = self else { return }
                self.deleteChoosenTrain()
                self.showDeletedTrainAlert()
        })
    }
    
    private func showDeletedTrainAlert() {
        AlertHelper.shared.showDefaultAlert(on: self,
                                            title: "Training was deleted",
                                            message: "",
                                            cancelTitle: nil,
                                            okTitle: LocalizedString.ok,
                                            style: .alert,
                                            completion: nil)
    }
    
    //MARK: - Constraint
    private func setUpConstrains() {
        let safeAre = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: safeAre.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: safeAre.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: safeAre.trailingAnchor)
        ])
    }
    
    private func setCollectionViewConstraint() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor,
                                                     constant: 8),
            self.collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                         constant: 16),
            self.collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                          constant: -16)
        ])
    }
    
    private func deactivateNotEmptyTrainingListConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.deactivate([
            self.collectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor,
                                                     constant: 8),
            self.collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                         constant: 16),
            self.collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                          constant: -16)
        ])
        
        NSLayoutConstraint.deactivate([
            self.headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setUpEmtyTrainingListLabelConstraints() {
        NSLayoutConstraint.activate([
            self.emptyTainingListLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emptyTainingListLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    private func deactivateEmtyTrainingListLabelConstraints() {
        NSLayoutConstraint.deactivate([
            self.emptyTainingListLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emptyTainingListLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    //MARK: - Actions
    @objc private func trainingWasAdded() {
        print("Ttrain list vc trainig was changed")
        self.setUpViewController()
        self.isTrainingChanged = true
    }
    
    @objc private func editingButtonPressed(_ sender: UIBarButtonItem) {
        //MARK: TODO - доделать удаление тренировки
        if self.isEditing {
            self.editTrainListButton.title = "Edit"
            self.trainingForDeleting.removeAll()
            self.deselectSelectedItem()
            self.isEditing = false
        } else {
            self.editTrainListButton.title = "Done"
            self.isEditing = true
            self.setUpViewController()
        }
    }
    
    @objc private func removeChoosenTrain() {
        self.showDeletingTrainAlert()
    }
}

//MARK: - CollectionView Extension
extension TrainingListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.trainList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTTrainCell.cellID,
                                                      for: indexPath)
        let train = self.trainList[indexPath.row]
        (cell as? DTTrainCell)?.setCellFor(train)
        (cell as? DTTrainCell)?.setGroupIcons(by: train.muscleGroupInCurrentTrain)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = self.collectionView.bounds.width / 2 - 8
        let itemHeight = itemWidth * 1.3
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isEditing {
            if let cell = collectionView.cellForItem(at: indexPath) as? DTTrainCell {
                cell.setBackgroundColorTo(.red)
            }
            self.trainingForDeleting[indexPath.row] = self.trainList[indexPath.row]
            self.setTrashButttonState()
        } else {
            self.pushTrainViewController(with: indexPath.row)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if self.isEditing {
            if let cell = collectionView.cellForItem(at: indexPath) as? DTTrainCell {
                cell.setBackgroundColorTo(.viewFlipsideBckgoundColor)
            }
            self.trainingForDeleting.removeValue(forKey: indexPath.row)
            self.setTrashButttonState()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.collectionView.allowsMultipleSelection = true
    }
}


