import UIKit
import CoreData

protocol EditableExerciseCellDelegate: AnyObject {
    func addButtonPressed(cell: EditableExerciceCell, approachesCount: Int)
    func deletButtonPressed(cell: EditableExerciceCell)
    
    func reloadExercise(cell: EditableExerciceCell)
    func didSelectItemIn(cell: EditableExerciceCell, approach: Approach, at indexPath: IndexPath)
    func hideAlert(cell: EditableExerciceCell)
}

final class EditableExerciceCell: UITableViewCell {
    
    
    weak var delegate: EditableExerciseCellDelegate?
    //MARK: - Private properties
    private var aproachItemSize: CGSize {
        let itemHeight = self.collectionView.bounds.height * 0.95
        let itemWidth = self.collectionView.bounds.width / 4
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
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
    
    private lazy var collectionView: UICollectionView = {
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
        super.init(style: style, reuseIdentifier: EditableExerciceCell.cellID)
        self.initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private(set) var presenter: EditableExerciseCellPresenterProtocol?
    
    //MARK: - Interface
    func setUpFor(_ exercise: ExerciseMO, indexPath: IndexPath) {
        configurePresenter(for: exercise)
        
        addAproachButton.tag = indexPath.row
        exerciceNameLabel.text = NSLocalizedString(exercise.name, comment: "")
        muscleSubGroupImage.image = exercise.subGroup?.image
        collectionView.reloadData()
     }
    
    private func configurePresenter(for exercise: ExerciseMO) {
        let presenter = EditableExerciseCellPresenter(exercise: exercise)
        presenter.output = self
        presenter.exercise = exercise
        self.presenter = presenter
        self.presenter?.loadAproaches()
    }
}

//MARK: - Private methods
private extension EditableExerciceCell {
    
    
    func initCell() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(self.containerView)
        self.contentView.addSubview(self.muscleSubGroupImage)
        self.contentView.addSubview(self.exerciceNameLabel)
        self.contentView.addSubview(self.collectionView)
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
            self.muscleSubGroupImage.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor,
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
            self.aproachesButtonStack.leftAnchor.constraint(equalTo: self.collectionView.rightAnchor,
                                                            constant: DTEdgeInsets.small.left),
            self.aproachesButtonStack.rightAnchor.constraint(equalTo: self.containerView.rightAnchor,
                                                             constant: DTEdgeInsets.small.right),
            //aproachesButtonStack.centerYAnchor.constraint(equalTo: aproachCollectionList.centerYAnchor)
            self.aproachesButtonStack.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16),
        ])
        
        
        NSLayoutConstraint.activate([
            self.collectionView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor,
                                                               constant: DTEdgeInsets.small.bottom),
            self.collectionView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                             constant: DTEdgeInsets.small.left),
            self.collectionView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor,
                                                              multiplier: 0.8),
            self.collectionView.heightAnchor.constraint(equalTo: self.containerView.heightAnchor,
                                                               multiplier: 0.5)
        ])
    }
    
    
    //MARK: - Actions
    @objc  func addButtonTouched() {
        delegate?.addButtonPressed(cell: self, approachesCount: presenter?.itemCount ?? 0)
    }
    
    @objc  func removeLastAproachesButtonPressed() {
        delegate?.deletButtonPressed(cell: self)
    }
    
    @objc func doneButtonAction() {
        presenter?.markExerciseAsDone()
    }
}

//MARK: - UICollectionViewDataSource
extension EditableExerciceCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.itemCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTAproachCell.cellID, for: indexPath)
        guard let aproach = presenter?.approach(at: indexPath) else { return UICollectionViewCell() }
        cell.as(type: DTAproachCell.self)?.setUpFor(aproach)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension EditableExerciceCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let approach = presenter?.approach(at: indexPath) else { return }
        let aproach = Approach(index: presenter?.itemCount ?? 0, reps: approach.reps.int, weight: approach.weightValue)
        delegate?.didSelectItemIn(cell: self, approach: aproach, at: indexPath)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension EditableExerciceCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.aproachItemSize
      }
}
extension EditableExerciceCell: EditableExerciseCellPresenterOutput {
    
    func exerciseIsDonde(isDone: Bool) {
        let doneImage = isDone ? UIImage(named: "checkmark_training")?.withTintColor(.green) :
            UIImage(named: "checkmark_training")?.withTintColor(.white)
        doneButton.setImage(doneImage, for: .normal)
        isUserInteractionEnabled = !isDone
    }
    
    func hideAlert() {
        delegate?.hideAlert(cell: self)
    }
    
    func reloadItem(at indexPath: IndexPath) {
        delegate?.hideAlert(cell: self)
        collectionView.performBatchUpdates({ collectionView.reloadItems(at: [indexPath]) }, completion: nil)
    }
    
    func insertItem(at indexPath: IndexPath) {
        delegate?.hideAlert(cell: self)
        collectionView.performBatchUpdates({ collectionView.insertItems(at: [indexPath]) }, completion: nil)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        delegate?.hideAlert(cell: self)
        collectionView.performBatchUpdates({ collectionView.deleteItems(at: [indexPath]) }, completion: nil)
    }
}
