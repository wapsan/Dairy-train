import UIKit

class DTExerciceCell: UITableViewCell {
    
    //MARK: - Static properties
    static let cellID = "TestExerciceCell"
    
    var exercice: Exercise?
    var addButtonAction: (()-> Void)?
    
    //MARK: - GUI Properties
    let muscleGroupImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "chest"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var exerciceNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Exercice name"
        label.textColor = .white
        label.numberOfLines = 2
        label.minimumScaleFactor = 1/2
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var aproachCollectionList: UICollectionView = {
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
    
    lazy var addAproachBurron: UIButton = {
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
        self.setUpContentView()
        self.setUpGuiElemetns()
        self.selectionStyle = .none
      
        
    }
    
    //MARK: - Private methods
    private func setUpGuiElemetns() {
        self.addSubview(self.muscleGroupImage)
        self.addSubview(self.exerciceNameLabel)
        self.addSubview(self.aproachCollectionList)
        self.addSubview(self.addAproachBurron)
        self.setUpConstraints()
    }
    
    private func setUpContentView() {
        self.contentView.backgroundColor = .viewFlipsideBckgoundColor
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.shadowColor = UIColor.darkGray.cgColor
        self.contentView.layer.shadowOffset = .init(width: 0, height: 5)
        self.contentView.layer.shadowOpacity = 5
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.muscleGroupImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,
                                                        constant: 8),
            self.muscleGroupImage.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                       constant: 8),
            self.muscleGroupImage.bottomAnchor.constraint(equalTo: self.aproachCollectionList.topAnchor,
                                                          constant: -8),
            self.muscleGroupImage.widthAnchor.constraint(equalTo: self.muscleGroupImage.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.exerciceNameLabel.leftAnchor.constraint(equalTo: self.muscleGroupImage.rightAnchor,
                                                         constant: 8),
            self.exerciceNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8),
            self.exerciceNameLabel.centerYAnchor.constraint(equalTo: self.muscleGroupImage.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.addAproachBurron.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8),
            self.addAproachBurron.leftAnchor.constraint(equalTo: self.aproachCollectionList.rightAnchor,
                                                        constant: 8),
            self.addAproachBurron.centerYAnchor.constraint(equalTo: self.aproachCollectionList.centerYAnchor),
            self.addAproachBurron.heightAnchor.constraint(equalTo: self.addAproachBurron.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.aproachCollectionList.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                               constant: -8),
            self.aproachCollectionList.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8),
            self.aproachCollectionList.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                              multiplier: 0.8),
            self.aproachCollectionList.heightAnchor.constraint(equalTo: self.contentView.heightAnchor,
                                                               multiplier: 0.5)
        ])
    }
    
    //MARK: - Actions
    @objc func addButtonTouched() {
//        self.exercice?.aproaches.append(Exercise.Approach(weight: 10, reps: 12))
//        self.aproachCollectionList.reloadData()
        self.addButtonAction?()
        
    }
    
}

extension DTExerciceCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exercice?.aproaches.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTAproachCell.cellID, for: indexPath) as! DTAproachCell
        if let exercice = self.exercice {
            let aproach = exercice.aproaches[indexPath.row]
            cell.aproachNumberLabel.text = "№ " + String(indexPath.row + 1)
        cell.weightLabel.text = String(aproach.weight) + " kg."
            cell.repsLabel.text = String(aproach.reps) + " reps."
        }
      //  cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = self.aproachCollectionList.bounds.height * 0.95
        let itemWidth = self.aproachCollectionList.bounds.width / 4
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
