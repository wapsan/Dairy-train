import UIKit

class DTTrainedMusclesView: UIView {
    
    //MARK: - Private properties
    private lazy var subgroupsList: [MuscleSubgroup.Subgroup] = []
    private lazy var edgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: -8, right: -8)
    
    //MARK: - GUI Properties
    private lazy var titleLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.text = LocalizedString.trainedMuscles
        label.font = .boldSystemFont(ofSize: 25.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return  label
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var subgroupCollectionList: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(DTMuscleSubgroupsCell.self,
                                forCellWithReuseIdentifier: DTMuscleSubgroupsCell.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - Initialization
    init(for subgroups: [MuscleSubgroup.Subgroup]?) {
        super.init(frame: .zero)
        guard let subgroupsFromTrain = subgroups else { return }
        self.subgroupsList = subgroupsFromTrain
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = .viewFlipsideBckgoundColor
        self.addSubview(self.titleLabel)
        self.addSubview(self.subgroupCollectionList)
        self.setUpConstraints()
        self.setDefaultLayer()
    }
    
    private func setDefaultLayer() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowOpacity = 5
        self.layer.cornerRadius = 25
    }

    //MARK: - Public methods
    func updateSubgroupsImages(for subgroups: [MuscleSubgroup.Subgroup]?) {
        guard let subgroupsFromTrain = subgroups else { return }
        self.subgroupsList = subgroupsFromTrain
        self.subgroupCollectionList.reloadData()
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                 constant: self.edgeInsets.top),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                  constant: self.edgeInsets.left),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                   constant: self.edgeInsets.right),
            self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                    multiplier: 0.25)
        ])
        
        NSLayoutConstraint.activate([
            self.subgroupCollectionList.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.subgroupCollectionList.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                              constant: self.edgeInsets.left),
            self.subgroupCollectionList.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                               constant: self.edgeInsets.right),
            self.subgroupCollectionList.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

//MARK: - CollectionViewDelegate and datasourse
extension DTTrainedMusclesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subgroupsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTMuscleSubgroupsCell.cellID,
                                                      for: indexPath)
        let submuscleGroupImage = self.subgroupsList[indexPath.row].image
        (cell as? DTMuscleSubgroupsCell)?.setCellImage(to: submuscleGroupImage)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.bounds.height
        let itemWidth = itemHeight
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        return itemSize
    }
}
