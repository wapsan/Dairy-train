import UIKit

class DTTrainedSubGroupCell: UICollectionViewCell {

    //MARK: - GUI Properties
    private lazy var subgroupsList: [MuscleSubgroup.Subgroup] = []
    private lazy var edgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: -8, right: -8)
    
    private var itemSize: CGSize {
        let itemHeight = self.subgroupCollectionList.bounds.height
        let itemWidth = itemHeight
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        return itemSize
    }
    
    //MARK: - GUI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIScreen.main.bounds.height / 30
        view.layer.borderWidth = 1
        view.layer.borderColor = DTColors.controllBorderColor.cgColor
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.subgroupCollectionList)
        self.setUpConstraints()
    }
    
    //MARK: - Setter
    func renderCell(for statistics: Statistics) {
        self.subgroupsList = statistics.trainedSubGroupsList
        self.subgroupCollectionList.reloadData()
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor,
                                                    constant: DTEdgeInsets.small.top),
            self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                     constant: DTEdgeInsets.small.left),
            self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                      constant: DTEdgeInsets.small.right),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                       constant: DTEdgeInsets.small.bottom),
            
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                 constant: DTEdgeInsets.small.top),
            self.titleLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                  constant: DTEdgeInsets.small.left),
            self.titleLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor,
                                                   constant: DTEdgeInsets.small.right),
            self.titleLabel.heightAnchor.constraint(equalTo: self.containerView.heightAnchor,
                                                    multiplier: 0.25)
        ])
        
        NSLayoutConstraint.activate([
            self.subgroupCollectionList.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.subgroupCollectionList.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                              constant: DTEdgeInsets.small.left),
            self.subgroupCollectionList.rightAnchor.constraint(equalTo: self.containerView.rightAnchor,
                                                               constant: DTEdgeInsets.small.right),
            self.subgroupCollectionList.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
        ])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension DTTrainedSubGroupCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
}

//MARK: - UICollectionViewDataSource
extension DTTrainedSubGroupCell: UICollectionViewDataSource {
    
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
}
