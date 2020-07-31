import UIKit

class DTEditingExerciceCell: UITableViewCell {
    
    //MARK: - Static properties
    static let cellID = "TestExerciceCell"
    
    //MARK: - Private properties
    private var exercise: ExerciseManagedObject?
    
    //MARK: - Properties
    var addAproachButtonAction: (() -> Void)?
    var removeAproachButtonAction: (() -> Void)?
    
    //MARK: - GUI Properties
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let muscleSubGroupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var exerciceNameLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var aproachCollectionList: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DTAproachCell.self, forCellWithReuseIdentifier: DTAproachCell.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var addAproachButton: UIButton = {
        let button = UIButton()
        let addImage = UIImage.dtAdd
        button.setImage(addImage, for: .normal)
        button.addTarget(self,
                         action: #selector(self.addButtonTouched),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var removeLastAproachButton: UIButton = {
        let button = UIButton()
        let removeImage = UIImage.dtRemove
        button.setImage(removeImage, for: .normal)
        button.addTarget(self,
                         action: #selector(self.removeLastAproachesButtonPressed),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var aproachesButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.removeLastAproachButton)
        stackView.addArrangedSubview(self.addAproachButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Layout subviews
    override func layoutSubviews() {
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.borderColor = DTColors.controllBorderColor.cgColor
        self.containerView.layer.borderWidth = 1
        super.layoutSubviews()
    }
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DTEditingExerciceCell.cellID)
        self.initCell()
    }
    
    private func initCell() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(self.containerView)
        
        self.contentView.addSubview(self.muscleSubGroupImage)
        self.contentView.addSubview(self.exerciceNameLabel)
        self.contentView.addSubview(self.aproachCollectionList)
        self.contentView.addSubview(self.aproachesButtonStack)
        self.containerView.backgroundColor = DTColors.controllUnselectedColor
        self.setUpNewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setter
    func setUpFor(_ exercise: ExerciseManagedObject) {
        self.exercise = exercise
        self.exerciceNameLabel.text = NSLocalizedString(exercise.name, comment: "") 
        self.muscleSubGroupImage.image = exercise.image
        self.aproachCollectionList.reloadData()
    }
    
    //MARK: - Constraints
    private func setUpNewConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor,
                                                    constant: DTEdgeInsets.small.top),
            self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                     constant: DTEdgeInsets.small.left),
            self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                      constant: DTEdgeInsets.small.right),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                       constant: DTEdgeInsets.small.bottom)
        ])
        
        NSLayoutConstraint.activate([
            self.muscleSubGroupImage.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                           constant: DTEdgeInsets.small.left),
            self.muscleSubGroupImage.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                          constant: DTEdgeInsets.small.top),
            self.muscleSubGroupImage.bottomAnchor.constraint(equalTo: self.aproachCollectionList.topAnchor,
                                                             constant: DTEdgeInsets.small.bottom),
            self.muscleSubGroupImage.widthAnchor.constraint(equalTo: self.muscleSubGroupImage.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.exerciceNameLabel.leftAnchor.constraint(equalTo: self.muscleSubGroupImage.rightAnchor,
                                                         constant: DTEdgeInsets.small.left),
            self.exerciceNameLabel.rightAnchor.constraint(equalTo: self.aproachesButtonStack.leftAnchor,
                                                          constant: DTEdgeInsets.small.right),
            self.exerciceNameLabel.centerYAnchor.constraint(equalTo: self.muscleSubGroupImage.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.aproachesButtonStack.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.aproachesButtonStack.leftAnchor.constraint(equalTo: self.aproachCollectionList.rightAnchor,
                                                            constant: DTEdgeInsets.small.left),
            self.aproachesButtonStack.rightAnchor.constraint(equalTo: self.containerView.rightAnchor,
                                                             constant: DTEdgeInsets.small.right),
            self.aproachesButtonStack.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
        ])
        
        
        NSLayoutConstraint.activate([
            self.aproachCollectionList.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor,
                                                               constant: DTEdgeInsets.small.bottom),
            self.aproachCollectionList.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                             constant: DTEdgeInsets.small.left),
            self.aproachCollectionList.widthAnchor.constraint(equalTo: self.containerView.widthAnchor,
                                                              multiplier: 0.8),
            self.aproachCollectionList.heightAnchor.constraint(equalTo: self.containerView.heightAnchor,
                                                               multiplier: 0.5)
        ])
    }
    
    //MARK: - Actions
    @objc private func addButtonTouched() {
        self.addAproachButtonAction?()
    }
    
    @objc private func removeLastAproachesButtonPressed() {
        self.removeAproachButtonAction?()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DTEditingExerciceCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exercise?.aproaches.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTAproachCell.cellID,
                                                      for: indexPath)
        guard let aproach = self.exercise?.aproachesArray[indexPath.row] else { return UICollectionViewCell() }
        (cell as? DTAproachCell)?.setUpFor(aproach)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = self.aproachCollectionList.bounds.height * 0.95
        let itemWidth = self.aproachCollectionList.bounds.width / 4
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let exercice = self.exercise else { return }
        guard let parentViewController = self.parentViewController else { return }
        DTCustomAlert.shared.showAproachAlert(on: parentViewController, with: exercice, and: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
