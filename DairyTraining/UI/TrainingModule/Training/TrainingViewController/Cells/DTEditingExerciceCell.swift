import UIKit

final class DTEditingExerciceCell: UITableViewCell {
    
    //MARK: - Static properties
    static let cellID = "TestExerciceCell"
    
    //MARK: - Private properties
    private var exercise: ExerciseManagedObject?
    private var aproachItemSize: CGSize {
        let itemHeight = self.aproachCollectionList.bounds.height * 0.95
        let itemWidth = self.aproachCollectionList.bounds.width / 4
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    //MARK: - Properties
    var addAproachButtonAction: (() -> Void)?
    var removeAproachButtonAction: (() -> Void)?
    var changeAproachAction: ((_ index: Int, _ weight: String, _ reps: String) -> Void)?
    var doneButtonPressedAction: (() -> Void)?
    private(set) var isDone: Bool = false
    
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
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(addImage, for: .normal)
        button.addTarget(self,
                         action: #selector(self.addButtonTouched),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var doneButton: UIButton = {
       let button = UIButton()
        //button.setImage(UIImage(named: "checkmark_training")?.withTintColor(.white), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeLastAproachButton: UIButton = {
        let button = UIButton()
        let removeImage = UIImage.dtRemove
        button.imageView?.contentMode = .scaleAspectFit
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
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.doneButton)
        stackView.addArrangedSubview(self.removeLastAproachButton)
        stackView.addArrangedSubview(self.addAproachButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.borderColor = DTColors.controllBorderColor.cgColor
        self.containerView.layer.borderWidth = 1
    }
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DTEditingExerciceCell.cellID)
        self.initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Interface
     func setUpFor(_ exercise: ExerciseManagedObject) {
        self.exercise = exercise
        exerciceNameLabel.text = NSLocalizedString(exercise.name, comment: "")
        muscleSubGroupImage.image = exercise.image
        aproachCollectionList.reloadData()
        markAsDone(isDone: exercise.isDone)
        self.isDone = exercise.isDone
     }
     
    func removeLastAproach() {
        guard let aproachesCount = self.exercise?.aproachesArray.count else { return }
        let lastAproachIndex = aproachesCount
        let indexPath = IndexPath(row: lastAproachIndex, section: 0)
        self.aproachCollectionList.performBatchUpdates({
            self.aproachCollectionList.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    func addAproach() {
        self.aproachCollectionList.reloadData()
        let indexPathes = self.aproachCollectionList.indexPathsForVisibleItems
        self.aproachCollectionList.insertItems(at: indexPathes)
    }
    
    func changeAproach(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.aproachCollectionList.reloadItems(at: [indexPath])
    }
    func markAsDone(isDone: Bool) {
        //containerView.backgroundColor = isDone ? .systemBlue : DTColors.controllUnselectedColor
        if isDone {
            doneButton.setImage(UIImage(named: "checkmark_training")?.withTintColor(.green), for: .normal)
            doneButton.isUserInteractionEnabled = false
        } else {
            doneButton.setImage(UIImage(named: "checkmark_training")?.withTintColor(.white), for: .normal)
        }
        isUserInteractionEnabled = !isDone
    }
}

//MARK: - Private methods
private extension DTEditingExerciceCell {
    
    
    
    func initCell() {
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
    
    //MARK: - Constraints
    func setUpNewConstraints() {
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
           // aproachesButtonStack.heightAnchor.constraint(equalTo: aproachCollectionList.heightAnchor, multiplier: 1),
            self.aproachesButtonStack.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16),
            self.aproachesButtonStack.leftAnchor.constraint(equalTo: self.aproachCollectionList.rightAnchor,
                                                            constant: DTEdgeInsets.small.left),
            self.aproachesButtonStack.rightAnchor.constraint(equalTo: self.containerView.rightAnchor,
                                                             constant: DTEdgeInsets.small.right),
            //aproachesButtonStack.centerYAnchor.constraint(equalTo: aproachCollectionList.centerYAnchor)
            self.aproachesButtonStack.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16),
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
    @objc  func addButtonTouched() {
        self.addAproachButtonAction?()
        
    }
    
    @objc  func removeLastAproachesButtonPressed() {
        self.removeAproachButtonAction?()
    }
    
    @objc func doneButtonAction() {
        doneButtonPressedAction?()
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DTEditingExerciceCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exercise?.aproaches.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTAproachCell.cellID,
                                                      for: indexPath)
        guard let aproach = self.exercise?.aproachesArray[indexPath.row] else { return UICollectionViewCell() }
        (cell as? DTAproachCell)?.setUpFor(aproach)
        (cell as? DTAproachCell)?.tapAction = { (weight, reps) in
            self.changeAproachAction?(indexPath.row, weight, reps)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension DTEditingExerciceCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.aproachItemSize
      }
}
