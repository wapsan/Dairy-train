//
//  WorkoutCell.swift
//  Dairy Training
//
//  Created by cogniteq on 12.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import UIKit

final class WorkoutCell: UITableViewCell {

    // MARK: - @IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var dateLabel: UILabel!
    
    
    private var subgorupImages: [UIImage?] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subgorupImages = []
    }

    // MARK: - Setup
    private func setup() {
        collectionView.register(DTMuscleSubgroupsCell.self, forCellWithReuseIdentifier: DTMuscleSubgroupsCell.cellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = DTColors.controllBorderColor.cgColor
    }
    
 
    
    func setCell(for workout: TrainingManagedObject) {
        guard let formatedDate = workout.formatedDate else { return }
        self.dateLabel.text = formatedDate
        workout.muscleSubgroupInCurentTraint.forEach({
            subgorupImages.append($0.image)
        })
        
        collectionView.reloadData()
    }
    
}

extension WorkoutCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subgorupImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DTMuscleSubgroupsCell.cellID, for: indexPath)
        let subgroupImage = subgorupImages[indexPath.row]
        (cell as? DTMuscleSubgroupsCell)?.setCellImage(to: subgroupImage)
        return cell
    }
}

extension WorkoutCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.bounds.width / 4
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
}

extension WorkoutCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
 

