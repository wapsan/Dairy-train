import UIKit

class TrainingListVC: MainTabBarItemVC {
    
    //MARK: - Properties
    lazy var headerTitle = "Your trains"
    private lazy var isTrainingChenged: Bool = false
    
    //MARK: - GUI Properties
    lazy var collectionView: UICollectionView = {
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
       
    lazy var headerView: DTHeaderView = {
        let view = DTHeaderView(title: self.headerTitle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emptyTainingListLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.text = "No training yet"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Properties
    var userTrainsList: [Train] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObserverForAddTrainToList()
        self.setUpViewController()
        let deleteTrainButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                                target: self,
                                                action: #selector(self.removeTrain))
        self.navigationItem.rightBarButtonItem  = deleteTrainButton
    }
    @objc private func removeTrain() {
        UserTrainingModelFileManager.shared.removeTrainingDataFromDevice()
        self.setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isTrainingChenged {
            self.setUpViewController()
            self.isTrainingChenged = false
        }
    }
    
    //MARK: - Private methods
    private func setUpViewController() {
       // self.userTrainsList = UserModel.shared.trains
        self.userTrainsList = UserTrainingModelFileManager.shared.trainingInfo.trainingList
        if self.userTrainsList.isEmpty {
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
       // let train = self.userTrainsList[trainIndex]
        let train = UserTrainingModelFileManager.shared.trainingInfo.trainingList[trainIndex]
        let trainVC = TrainingVC()
        trainVC.train = train
        trainVC.headerTittle = train.dateTittle
        self.navigationController?.pushViewController(trainVC, animated: true)
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
        self.isTrainingChenged = true
    }
}

//MARK: - CollectionView Extension
extension TrainingListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userTrainsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTTrainCell.cellID,
                                                      for: indexPath) as! DTTrainCell
       // let train = userTrainsList[indexPath.row]
        let train = UserTrainingModelFileManager.shared.trainingInfo.trainingList[indexPath.row]
        cell.dateLabel.text = train.dateTittle
        cell.setGroupIcons(by: train.groupsInCurrentTrain)
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
        let trainIndex = indexPath.row
        self.pushTrainViewController(with: trainIndex)
    }
    
}



