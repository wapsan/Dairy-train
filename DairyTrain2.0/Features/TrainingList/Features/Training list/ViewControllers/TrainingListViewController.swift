import UIKit

class TrainingListViewController: MainTabBarItemVC {
    
    //MARK: - Private properties
    private lazy var isTrainingChenged: Bool = false
    private lazy var trainList: [TrainingManagedObject] = []
    private lazy var trainingForDeleting: [Int: TrainingManagedObject] = [:]
    
    private var isEditingMode: Bool = false {
        didSet {
            self.navigationItem.rightBarButtonItem = oldValue == false ? self.deleteTrainButton : nil
        }
    }
    
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
    
    private lazy var deleteTrainButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                            target: self,
                                            action: #selector(self.removeChoosenTrain))
        return barButtonItem
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
        if self.isTrainingChenged {
            self.setUpViewController()
            self.isTrainingChenged = false
        }
    }
    
    //MARK: - Private methods
    private func setUpTrainList() {
        self.trainList = CoreDataManager.shared.fetchTrainingList()
    }
    
    private func setUpEditingButton() {
//        let editingButton = UIBarButtonItem(barButtonSystemItem: .edit,
//                                            target: self,
//                                            action: #selector(self.editingButtonPressed(_:)))
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
        let train = self.trainList[trainIndex]
        let trainVC = TrainingVC()
        trainVC.train = train
        trainVC.headerTittle = train.formatedDate ?? "0"
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
    
    @objc private func editingButtonPressed(_ sender: UIBarButtonItem) {
        if self.isEditingMode {
            self.editTrainListButton.title = "Edit"
            self.trainingForDeleting.removeAll()
            for train in self.trainList {
                train.isSelected = false
            }
            self.isEditingMode = false
        } else {
            self.editTrainListButton.title = "Done"
            self.isEditingMode = true
            self.setUpViewController()
        }
    }
    
    @objc private func removeChoosenTrain() {
        self.setUpViewController()
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
        (cell as? DTTrainCell)?.dateLabel.text = train.formatedDate
        (cell as? DTTrainCell)?.setGroupIcons(by: train.muscleGroupInCurrentTrain)
        (cell as? DTTrainCell)?.tapAction = {
            
            // train.isSelected = true
            
            if train.isSelected {
                self.trainingForDeleting.removeValue(forKey: indexPath.row)
              //  self.trainingForDeleting.remove(at: indexPath.row)
              //  (cell as? DTTrainCell)?.containerView.backgroundColor = .viewFlipsideBckgoundColor
                train.isSelected = false
            } else {
                self.trainingForDeleting[indexPath.row] = self.trainList[indexPath.row]
              //  self.trainingForDeleting.append(self.trainList[indexPath.row])
               // (cell as? DTTrainCell)?.containerView.backgroundColor = .red
                train.isSelected = true
            }
    
         
//            print("Deleting train count - \(self.trainingForDeleting.count)")
//            for (key, value) in self.trainingForDeleting {
//                
//                print("Key - \(key), date of train - \(train.formatedDate)")
//            }
            collectionView.reloadData()
        }
        
        if train.isSelected {
          //  self.trainingForDeleting.removeValue(forKey: indexPath.row)
          //  self.trainingForDeleting.remove(at: indexPath.row)
            (cell as? DTTrainCell)?.containerView.backgroundColor = .red
          //  train.isSelected = false
        } else {
           // self.trainingForDeleting[indexPath.row] = self.trainList[indexPath.row]
          //  self.trainingForDeleting.append(self.trainList[indexPath.row])
            (cell as? DTTrainCell)?.containerView.backgroundColor = .viewFlipsideBckgoundColor
           // train.isSelected = true
        }
        if self.isEditingMode {
            (cell as? DTTrainCell)?.addTapAction()
        } else {
            (cell as? DTTrainCell)?.removeTapAction()
        }
        if !self.trainingForDeleting.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
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
        if !self.isEditingMode {
            let trainIndex = indexPath.row
            self.pushTrainViewController(with: trainIndex)
//            if self.trainList[indexPath.row].isSelected {
//                self.trainingForDeleting.remove(at: indexPath.row)
//                self.trainList[indexPath.row].isSelected = false
//            } else {
//                self.trainingForDeleting.append(trainList[indexPath.row])
//                self.trainList[indexPath.row].isSelected = true
//            }
            
//            for train in trainList {
//                if train.isSelected {
//
//                    train.isSelected = false
//                } else {
//                    train.isSelected = true
//                }
//            }
          //  self.trainList[indexPath.row].isSelected = false
          //  self.isEditingMode = false
   //         self.collectionView.reloadData()
        } else {
            
        }
//
        
      
    }
    
  


}



