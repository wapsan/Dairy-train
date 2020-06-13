import UIKit

class DTEditingExerciceCell: UITableViewCell {
    
    //MARK: - Static properties
    static let cellID = "TestExerciceCell"
    
    //MARK: - Private properties
    private  var exercise: Exercise?
    var addButtonAction: (()-> Void)?
    
    //MARK: - GUI Properties
    private var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .viewFlipsideBckgoundColor
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = .init(width: 0, height: 5)
        view.layer.shadowOpacity = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let muscleSubGroupImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "chest"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var exerciceNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Exercice name"
        label.textColor = .white
        label.numberOfLines = 2
        label.minimumScaleFactor = 1/2
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aproachCollectionList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DTAproachCell.self, forCellWithReuseIdentifier: DTAproachCell.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var addAproachBurron: UIButton = {
        let button = UIButton()
        let addImage = UIImage(named: "add")
        button.setImage(addImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(self.addButtonTouched), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DTEditingExerciceCell.cellID)
        self.initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func setUpFor(_ exercise: Exercise) {
        self.exercise = exercise
        self.exerciceNameLabel.text = exercise.name
        self.muscleSubGroupImage.image = exercise.muscleSubGroupImage
        self.aproachCollectionList.reloadData()
    }
    
//    func reloadAproachList() {
//        self.aproachCollectionList.reloadData()
//    }
    
    //MARK: - Private methods
    private func initCell() {
        self.selectionStyle = .none
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.muscleSubGroupImage)
        self.containerView.addSubview(self.exerciceNameLabel)
        self.containerView.addSubview(self.aproachCollectionList)
        self.containerView.addSubview(self.addAproachBurron)
        self.setUpConstraints()
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8),
            self.containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            self.muscleSubGroupImage.leftAnchor.constraint(equalTo: self.containerView.leftAnchor,
                                                           constant: 8),
            self.muscleSubGroupImage.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                          constant: 8),
            self.muscleSubGroupImage.bottomAnchor.constraint(equalTo: self.aproachCollectionList.topAnchor,
                                                             constant: -8),
            self.muscleSubGroupImage.widthAnchor.constraint(equalTo: self.muscleSubGroupImage.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.exerciceNameLabel.leftAnchor.constraint(equalTo: self.muscleSubGroupImage.rightAnchor,
                                                         constant: 8),
            self.exerciceNameLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -8),
            self.exerciceNameLabel.centerYAnchor.constraint(equalTo: self.muscleSubGroupImage.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.addAproachBurron.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -8),
            self.addAproachBurron.leftAnchor.constraint(equalTo: self.aproachCollectionList.rightAnchor,
                                                        constant: 8),
            self.addAproachBurron.centerYAnchor.constraint(equalTo: self.aproachCollectionList.centerYAnchor),
            self.addAproachBurron.heightAnchor.constraint(equalTo: self.addAproachBurron.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.aproachCollectionList.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor,
                                                               constant: -8),
            self.aproachCollectionList.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 8),
            self.aproachCollectionList.widthAnchor.constraint(equalTo: self.containerView.widthAnchor,
                                                              multiplier: 0.8),
            self.aproachCollectionList.heightAnchor.constraint(equalTo: self.containerView.heightAnchor,
                                                               multiplier: 0.5)
        ])
    }
    
    //MARK: - Actions
    @objc func addButtonTouched() {
        self.addButtonAction?()
    }
}

extension DTEditingExerciceCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exercise?.aproaches.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTAproachCell.cellID,
                                                         for: indexPath) as? DTAproachCell {
            guard let exercise = self.exercise else { return UICollectionViewCell() }
            let aproach = exercise.aproaches[indexPath.row]
            cell.weightLabel.text = aproach.weightDisplayvalue
            cell.repsLabel.text = aproach.repsDisplayValue
            cell.aproachNumberLabel.text = "№ " + String(indexPath.row + 1)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
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


