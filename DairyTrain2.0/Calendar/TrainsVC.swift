import UIKit

class TrainsVC: MainTabBarItemVC {
    
    //MARK: - Properties
    lazy var headerTitle = "Your trains"
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Private methods
    private func setUpViewController() {
        self.userTrainsList = UserModel.shared.trains
        if self.userTrainsList.isEmpty {
            self.setUpEmptyTrainingList()
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
        let train = self.userTrainsList[trainIndex]
        let trainVC = TrainVC()
        trainVC.train = train
        trainVC.headerTittle = train.dateTittle
        self.navigationController?.pushViewController(trainVC, animated: true)
    }
    
    private func addObserverForAddTrainToList() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingWasAdded),
                                               name: .addNewTrain,
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
        self.setUpViewController()
    }
}

//MARK: - CollectionView Extension
extension TrainsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userTrainsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTTrainCell.cellID,
                                                      for: indexPath) as! DTTrainCell
        let train = userTrainsList[indexPath.row]
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



