import UIKit

class TrainsVC: MainTabBarItemVC {
    
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
        let view = DTHeaderView(title: "Your trains")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Properties
    var userTrainsList: [Train] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setHeaderView()
        self.setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userTrainsList = UserModel.shared.trains
        self.collectionView.reloadData()
    }
    
    //MARK: - Private methods
    private func setHeaderView() {
        self.view.addSubview(self.headerView)
        self.setUpConstrains()
    }
    
    private func setUpCollectionView() {
        self.view.addSubview(self.collectionView)
        self.setCollectionViewConstraint()
    }
    
    private func pushTrainViewController(with trainIndex: Int) {
        let train = self.userTrainsList[trainIndex]
        let trainVC = TrainVC()
        trainVC.train = train
        trainVC.headerTittle = train.dateTittle
        self.navigationController?.pushViewController(trainVC, animated: true)
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



